import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  bool isEditName = false;
  TextEditingController name = TextEditingController();
  String userName = ' ';
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        currentUser = user;
        if (currentUser != null) {
          this.userName = currentUser.email.split('@')[0];
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 80.0,
              backgroundColor: Colors.grey,

              child: Text(
                userName[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 80.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Visibility(
              visible: !isEditName,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    isEditName = true;
                    name.text = userName;
                  });
                },
                child: Text(
                  userName,
                  style: TextStyle(
                      fontSize: 50.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isEditName,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: name,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  this.isEditName = false;
                  this.userName = name.text;
                });
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
