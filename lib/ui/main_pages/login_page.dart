import 'package:barcode_scanner/ui/main_pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordContoller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150,
              width: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/store.jpg')
                ),
              ),
            ),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (username) {
                if (username.isEmpty) return 'Please enter a username';
              },
            ),
            TextFormField(
              obscureText: true,
              controller: passwordContoller,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (password) {
                if (password.isEmpty) return 'Please enter a password';
              },
            ),
            RaisedButton(
              child: const Text('Sign In'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _scaffoldKey.currentState.showSnackBar(const SnackBar(
                    content: Text('Logging In'),
                  ));
                  try {
                    final user =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: usernameController.text + '@carlson.com',
                      password: passwordContoller.text,
                    );
                    if (user != null) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  } on PlatformException catch (onError) {
                    String error;
                    switch (onError.code) {
                      case 'ERROR_WRONG_PASSWORD':
                        error = 'Invalid password';
                        break;
                      case 'ERROR_USER_NOT_FOUND':
                        error = 'User not found';
                        break;
                      default:
                        error = 'Error';
                    }
                    _scaffoldKey.currentState
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text(error),
                        backgroundColor: Colors.red,
                      ));
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
