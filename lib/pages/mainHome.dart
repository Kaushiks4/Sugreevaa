import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sugreeva/models/post.dart';
import 'package:sugreeva/pages/addComplaint.dart';
import 'package:sugreeva/pages/adminLogin.dart';
import 'package:sugreeva/pages/registerUser.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  List<Post> items;
  String message;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    items = new List();
    final dbRef = FirebaseDatabase.instance.reference().child('Posts');
    await dbRef.limitToLast(20).once().then((DataSnapshot data) {
      Map<dynamic, dynamic> posts = data.value;
      if (posts != null) {
        for (var key in posts.keys) {
          items.add(Post(
              place: posts[key]['place'],
              file: posts[key]['file'],
              description: posts[key]['description'],
              date: key));
        }
        items.sort(
            (a, b) => b.date.substring(0, 2).compareTo(a.date.substring(0, 2)));
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            message = 'No posts found!';
            loading = false;
          });
        }
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
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 3,
            ))
          : items.length > 0
              ? RefreshIndicator(
                  onRefresh: loadData,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Image(
                                image: AssetImage('assets/sugreeva.jpg'),
                                height: 50,
                              ),
                              title: Text(
                                items[index].place.toString(),
                                style: TextStyle(fontSize: 25),
                              ),
                              subtitle: Text(
                                items[index].date.toString().substring(0, 10),
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CachedNetworkImage(
                              imageUrl: items[index].file,
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                            ListTile(
                              leading: Icon(Icons.comment),
                              title: Text(
                                items[index].description.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                  message,
                  style: TextStyle(fontSize: 20),
                )),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SingleChildScrollView(
              child: DrawerHeader(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                      color: Colors.white, fontSize: 30, letterSpacing: 1),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
            ),
            ListTile(
                title: Text("Dhwani Login"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AdminLogin()));
                }),
            ListTile(
                title: Text("Register as Dhwani User"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new RegisterAsUser()));
                }),
            ListTile(
                title: Text("Raise Complaints"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AddComplaint()));
                }),
          ],
        ),
      ),
    );
  }
}
