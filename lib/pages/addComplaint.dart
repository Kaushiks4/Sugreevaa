import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sugreeva/pages/mainHome.dart';

class AddComplaint extends StatefulWidget {
  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  final _formKey = GlobalKey<FormState>();
  String place, description, fileLink, district, taluk, name, phNo;
  String filename, path, today;
  File file;

  final DateTime d = new DateTime.now();
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy-HH:mm:SS ');

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return Scaffold(
        appBar: AppBar(
          title: Text('Sugreevaa Dhwani'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Complaint',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: RaisedButton(
                  onPressed: () async {
                    pr.style(
                      message: 'Opening...',
                      borderRadius: 10.0,
                      backgroundColor: Colors.white,
                      progressWidget: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                      elevation: 10.0,
                      insetAnimCurve: Curves.easeInOut,
                    );
                    await pr.show();
                    await filePicker(context, pr);
                    pr.hide();
                    Fluttertoast.showToast(
                        msg: "Photo uploaded successfulyy!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[200],
                        textColor: Colors.black,
                        fontSize: 16.0);
                  },
                  child: Text(
                    'Choose Photo/Video',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 5, 50, 0),
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
                              district = val.trim();
                            });
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'District',
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
                          validator: (val) => val.isEmpty ? 'Required' : null,
                          onChanged: (val) {
                            setState(() {
                              taluk = val.trim();
                            });
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Taluk',
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
                          validator: (val) => val.isEmpty ? 'Required' : null,
                          onChanged: (val) {
                            setState(() {
                              place = val.trim();
                            });
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Place/Location with ward',
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
                          validator: (val) => val.isEmpty ? 'Required' : null,
                          onChanged: (val) {
                            setState(() {
                              description = val.trim();
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Description/Complaint Details',
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
                          validator: (val) => val.isEmpty ? 'Required' : null,
                          onChanged: (val) {
                            setState(() {
                              name = val.trim();
                            });
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Your Name',
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          keyboardType: TextInputType.number,
                          validator: (val) => val.isEmpty
                              ? 'Required'
                              : (val.length > 10 || val.length < 10)
                                  ? 'Invalid Phone Number'
                                  : null,
                          onChanged: (val) {
                            setState(() {
                              phNo = val.trim();
                            });
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Phone Number',
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
                    )),
              ),
              SizedBox(height: 20.0),
              SizedBox(height: 20.0),
              Center(
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate() && file != null) {
                      pr.style(
                        message: 'Uploading...',
                        borderRadius: 10.0,
                        backgroundColor: Colors.white,
                        progressWidget: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                        elevation: 10.0,
                        insetAnimCurve: Curves.easeInOut,
                      );
                      await pr.show();
                      await uploadDetails();
                      pr.hide();
                      Fluttertoast.showToast(
                          msg: "Complaint sent successfulyy!",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[200],
                          textColor: Colors.black,
                          fontSize: 16.0);
                      Future.delayed(Duration(seconds: 1), () async {
                        await Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new Home()));
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "No file Chosen!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[200],
                          textColor: Colors.black,
                          fontSize: 16.0);
                    }
                  },
                  child: Text(
                    'Upload',
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
        ));
  }

  Future uploadDetails() async {
    today = _dateFormat.format(d);
    final complaintRef =
        FirebaseDatabase.instance.reference().child('Complaints');
    await complaintRef.child(district).child(taluk).child(today).set({
      'place': place,
      'file': fileLink,
      'description': description,
      'name': name,
      'phoneNo': phNo,
      'date': today
    });
  }

  Future<void> _uploadFile() async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child(filename);
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    String link = await downloadUrl.ref.getDownloadURL();
    if (mounted) {
      setState(() {
        fileLink = link;
      });
    }
  }

  Future filePicker(BuildContext context, ProgressDialog pr) async {
    today = _dateFormat.format(d);
    try {
      file = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
      if (file == null) {
        pr.hide();
        Fluttertoast.showToast(
            msg: "No file Chosen!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[200],
            textColor: Colors.black,
            fontSize: 16.0);
      } else if (mounted) {
        setState(() {
          filename = today + file.path.split('/').last.split('.').last;
        });
      }
      await _uploadFile();
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Connection Error!!'),
              content: Text('Unsupported file format' + e.toString()),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
