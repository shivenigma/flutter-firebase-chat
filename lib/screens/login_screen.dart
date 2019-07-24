import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../widgets/action_button.dart';
import '../constants.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (BuildContext context) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                  kTextFiledDecoration.copyWith(hintText: 'Enter your Email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFiledDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                ActionButton(
                  color: Colors.lightBlueAccent,
                  label: Text(
                    'Log In',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        if(user.displayName != null) {
                          Navigator.pushNamedAndRemoveUntil(context, ChatScreen.route,(_) => false);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(context, ProfileScreen.route, (_) => false);
                        }
                      }
                    } catch (e) {
                      print(e.code);
                      var authError;
                      switch (e.code) {
                        case 'ERROR_INVALID_EMAIL':
                          authError = 'Invalid Email';
                          break;
                        case 'ERROR_USER_NOT_FOUND':
                          authError = 'User Not Found';
                          break;
                        case 'ERROR_WRONG_PASSWORD':
                          authError = 'Wrong Password';
                          break;
                        default:
                          authError = 'Something went wrong, Please try later';
                          break;
                      }
                      final snackBar = SnackBar(
                        content: Text(authError),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {
                            Scaffold.of(context).hideCurrentSnackBar();
                          },
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      })
    );
  }
}
