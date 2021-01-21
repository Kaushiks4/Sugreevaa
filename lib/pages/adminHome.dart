import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sugreeva/models/complaint.dart';
import 'package:sugreeva/pages/addAdmin.dart';
import 'package:sugreeva/pages/viewComplaint.dart';
import 'package:sugreeva/pages/workupload.dart';

class AdminHome extends StatefulWidget {
  String user;

  AdminHome(this.user);
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool loading = true;
  List<Complaint> items;
  var rowLength, rowHeight;

  @override
  void initState() {
    items = new List();
    loadData();
    super.initState();
  }

  Future loadData() async {
    final dbref = FirebaseDatabase.instance.reference().child("Complaints");
    await dbref.once().then((DataSnapshot data) {
      Map<dynamic, dynamic> complaints = data.value;
      if (complaints != null) {
        for (var district in complaints.keys) {
          for (var taluk in complaints[district].keys) {
            for (var key in complaints[district][taluk].keys) {
              items.add(Complaint(
                  district: district,
                  taluk: taluk,
                  file: complaints[district][taluk][key]['file'].toString(),
                  description: complaints[district][taluk][key]['description']
                      .toString(),
                  place: complaints[district][taluk][key]['place'].toString(),
                  name: complaints[district][taluk][key]['name'].toString(),
                  phone: complaints[district][taluk][key]['phoneNo'].toString(),
                  date: key));
            }
          }
        }
      }
      rowLength = items.length;
      rowHeight = (MediaQuery.of(context).size.height - 56) / rowLength;
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  Widget dataBody() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Complaints',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      'District',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text(
                      'Place',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Issue',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: items
                    .map((complaint) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                complaint.district,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new ViewComplaint(
                                          complaint.district,
                                          complaint.taluk,
                                          complaint.date))),
                            ),
                            DataCell(
                              Text(
                                complaint.place,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new ViewComplaint(
                                          complaint.district,
                                          complaint.taluk,
                                          complaint.date))),
                            ),
                            DataCell(
                              Text(
                                complaint.description,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new ViewComplaint(
                                          complaint.district,
                                          complaint.taluk,
                                          complaint.date))),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sugreevaa Dhwani'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: loading
            ? Center(child: CircularProgressIndicator(strokeWidth: 3))
            : (items.isEmpty)
                ? Center(
                    child: Text(
                    'No Complaints found!!',
                    style: TextStyle(fontSize: 20),
                  ))
                : dataBody(),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SingleChildScrollView(
            child: DrawerHeader(
              child: Text(
                'Welcome ' + widget.user,
                style: TextStyle(color: Colors.white, letterSpacing: 1),
              ),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
          ListTile(
            title: Text('Works Upload'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new WorkUpload(widget.user)));
            },
          ),
          ListTile(
            title: Text('Add Admin'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new AddAdmin(widget.user)));
            },
          ),
        ],
      )),
    );
  }
}
