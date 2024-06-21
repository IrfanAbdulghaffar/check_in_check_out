// login_screen.dart
import 'package:check_in_check_out/common/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:check_in_check_out/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'check_in_check_out_screen.dart';
import 'common/widget/app_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomAppBar(
      //   title: "Login",
      // ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50,),
                Image.asset("assets/images/sign_in_image.png"),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:80.0),
                  child: CustomButton(
                    title:"Login", onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      User? result = await _auth.signInWithEmail(email, password);
                      if (result == null) {
                        setState(() => error = 'Could not sign in with those credentials');
                      } else {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('isLoggedIn', true);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => CheckInCheckOutScreen()));
                      }
                    }
                  } ,
                  ),
                ),
                const SizedBox(height: 12.0),
                error!=""?Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ):const SizedBox(),
                TextButton(
                  child: const Text('Register here'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
