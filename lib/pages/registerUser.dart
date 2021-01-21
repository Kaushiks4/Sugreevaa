import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterAsUser extends StatefulWidget {
  @override
  _RegisterAsUserState createState() => _RegisterAsUserState();
}

class _RegisterAsUserState extends State<RegisterAsUser> {
   final _formKey = GlobalKey<FormState>();
   String name,password;

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
                      'Register',
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
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
                                name = val.trim();
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
                          SizedBox(height: 20.0),
                          TextFormField(
                            obscureText: true,
                            validator: (val) => val.isEmpty ? 'Required' : (val == password) ? null : 'Passwords don\'t match',
                            onChanged: (val) {
                              setState(() {
                                password = val.trim();
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm Password',
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
                          await pr.show();
                          await register(pr);
                          pr.hide();
                           Fluttertoast.showToast(
                                msg: "User added Successfully successfulyy!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey[200],
                                textColor: Colors.black,
                                fontSize: 16.0
                            );
                          Future.delayed(Duration(seconds: 1), () async {
                              await Navigator.of(context).pop();
                            });
                        }
                      },
                      child: Text(
                        'Register',
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

  Future register(ProgressDialog pr) async {
    final userRef = FirebaseDatabase.instance.reference().child("Users");
    await userRef.child(name).set({
      'password' : password,
    });
  }
}