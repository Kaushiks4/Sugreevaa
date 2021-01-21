import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ViewComplaint extends StatefulWidget {
  String district, taluk, ref;

  ViewComplaint(this.district, this.taluk, this.ref);

  @override
  _ViewComplaintState createState() => _ViewComplaintState();
}

class _ViewComplaintState extends State<ViewComplaint> {
  bool loading = true;
  var items = {};
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future loadData() async {
    final complaintRef = FirebaseDatabase.instance
        .reference()
        .child("Complaints")
        .child(widget.district)
        .child(widget.taluk);
    await complaintRef.child(widget.ref).once().then((DataSnapshot data) {
      Map<dynamic, dynamic> details = data.value;
      items['place'] = details['place'].toString();
      items['file'] = details['file'].toString();
      items['desc'] = details['description'].toString();
      items['name'] = details['name'].toString();
      items['phNo'] = details['phoneNo'].toString();
      items['dateTime'] = details['date'].toString();
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sugreevaa Dhwani'),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(strokeWidth: 3))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Date: ' + widget.ref.substring(0, 10),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'District: ' + widget.district,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Taluk: ' + widget.taluk + ' ' + items['place'],
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: CachedNetworkImage(
                        imageUrl: items['file'],
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Uploaded by: ' + items['name'],
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Uploader\'s Phone No: ' + items['phNo'],
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Description: ' + items['desc'],
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )),
    );
  }
}
