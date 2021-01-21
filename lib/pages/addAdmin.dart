import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddAdmin extends StatefulWidget {
  String user;

  AddAdmin(this.user);
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  bool loading = true;
  String user;
  List<String> users, admins;
  List<DropdownMenuItem<String>> dropDownItems;
  var map = {};

  @override
  void initState() {
    admins = new List();
    users = new List();
    getUsers();
    loadData();
    super.initState();
  }

  Future getUsers() async {
    final userRef = FirebaseDatabase.instance.reference().child('Users');
    await userRef.once().then((DataSnapshot data) {
      Map<dynamic, dynamic> usrs = data.value;
      for (var user in usrs.keys) {
        users.add(user.toString());
        map[user] = usrs[user]['password'];
      }
      dropDownItems = getItems();
    });
  }

  List<DropdownMenuItem<String>> getItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String user in users) {
      items.add(new DropdownMenuItem(child: new Text(user), value: user));
    }
    user = items[0].value;
    return items;
  }

  Future loadData() async {
    final adminRef = FirebaseDatabase.instance.reference().child('Admins');
    await adminRef.once().then((DataSnapshot data) {
      Map<dynamic, dynamic> users = data.value;
      for (var user in users.keys) {
        admins.add(user);
      }
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  bool isAdmin() => (widget.user == 'Sugreevaa') ? true : false;

  Widget adminBody(ProgressDialog pr) => SingleChildScrollView(
          child: Column(
        children: [
          Center(
            child: DropdownButton(
              items: dropDownItems,
              onChanged: changedDrop,
              value: user,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: RaisedButton(
              onPressed: () async {
                pr.style(
                  message: 'Adding..',
                  borderRadius: 10.0,
                  backgroundColor: Colors.white,
                  progressWidget: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                  elevation: 10.0,
                  insetAnimCurve: Curves.easeInOut,
                );
                await pr.show();
                await addAdmin();
                pr.hide();
                Fluttertoast.showToast(
                    msg: "Admin added Successfully!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey[200],
                    textColor: Colors.black,
                    fontSize: 16.0);
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new AddAdmin(widget.user)));
              },
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          )
        ],
      ));

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sugreevaa Dhwani'),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            )
          : Column(children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: ListView.builder(
                  itemCount: admins.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(admins[index]),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isAdmin() ? adminBody(pr) : Container(),
            ]),
    );
  }

  Future addAdmin() async {
    final adminRef = FirebaseDatabase.instance.reference().child('Admins');
    await adminRef.child(user).set({
      'password': map[user],
    });
  }

  void changedDrop(String purpo) {
    if (mounted) {
      setState(() {
        user = purpo;
      });
    }
  }
}
