import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sugreeva/pages/adminHome.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
    final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String error  = '';

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sugreevaa Dhwani'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
           child: Container(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      error,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50.0,5,50,0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.0),
                          TextFormField(
                            validator: (val) => val.isEmpty ? 'Required' : null,
                            onChanged: (val) {
                              setState(() {
                                username = val.trim();
                              });
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Username',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 6.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            obscureText: true,
                            validator: (val) => val.isEmpty ? 'Required' : null,
                            onChanged: (val) {
                              setState(() {
                                password = val.trim();
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 6.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: RaisedButton(
                      onPressed:() async {
                        if(_formKey.currentState.validate()) {
                          pr.style(
                            message: 'Logging in...',
                            borderRadius: 10.0,
                            backgroundColor: Colors.white,
                            progressWidget: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                            elevation: 10.0,
                            insetAnimCurve: Curves.easeInOut,
                          );
                          await pr.show();
                          dynamic res = await signIn(pr);
                          if (res != null) {
                            pr.hide();
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => new AdminHome(username)));
                          } else{
                            pr.hide();
                            setState(() {
                              error = 'Invalid username';
                            });
                          }
                        }
                      },
                      child: Text(
                        'Sign In',
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
                  ),
                ],
              ),
            )
          ),
          ),
      backgroundColor: Colors.white,
    );
  }

  Future signIn(ProgressDialog pr) async {
    var flag = 0;
    var usr;
    final adminRef = FirebaseDatabase.instance.reference().child('Admins');
    await adminRef.once().then((DataSnapshot data){
      Map<dynamic,dynamic> users = data.value;
      for(var user in users.keys){
        if(user == username){ 
          if(users[user]['password'].toString() == password){
            flag = 1;
            usr = user;
            break;
          } else{
            if(mounted){
              pr.hide();
              setState(() {
                error = 'Incorrect password';
              });                     
            }
          }
        }
      }
    }); 
    if(flag == 0){
      return null;
    }
    else{
      return usr;
    }
  }
}