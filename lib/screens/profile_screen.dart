import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import '../constants.dart';

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
  String gender;
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
            Flexible(
              child: CircleAvatar(
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
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(fontSize: 25.0),
                        textAlign: TextAlign.center,
                        controller: name,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Visibility(
              visible: isEditName,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Flexible(child: Image.asset('images/icons8-user-male-50.png')),
                      Radio(
                        groupValue: gender,
                        value: 'male',
                      )
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                  Column(
                    children: <Widget>[
                      Flexible(child: Image.asset('images/icons8-female-user-50.png')),
                      Radio(
                        groupValue: gender,
                        value: 'female',
                      )
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                  /*RadioListTile<String>(
                    title: const Text('Male', style: kRadioButtonLabelStyle,),
                    value: 'male',
                    groupValue: gender,
                    onChanged: (String value) {
                      setState(() { gender = value; });
                      },
                  ),
                  RadioListTile<String>(
                    title: const Text('Female', style: kRadioButtonLabelStyle),
                    value: 'female',
                    groupValue: gender,
                    onChanged: (String value) {
                      setState(() { gender = value; });
                    },
                  )*/
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async{
                    try {
                      setState(() {
                        this.isEditName = false;
                        this.userName = name.text;
                      });
                      UserUpdateInfo update = UserUpdateInfo();
                      update.displayName = name.text;
                      await currentUser.updateProfile(update);
                      Navigator.pushNamed(context, ChatScreen.route);
                    } catch(e) {
                      print(e);
                    }
                  },
                  child: Text('Save'),

                ),
                SizedBox(width: 15),
                RaisedButton(
                  onPressed: () async{
                    setState(() {
                      this.isEditName = false;
                    });
                  },
                  child: Text('Cancel'),

                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
