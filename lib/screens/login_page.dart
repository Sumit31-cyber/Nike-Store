import 'package:dealuxe/screens/register_page.dart';
import 'package:dealuxe/widgets/custom_btn.dart';
import 'package:dealuxe/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Container(
            child: Text(error),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('close Dialog'))
          ],
        );
      },
    );
  }

  // Create a new user account
  Future<String?> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
      return e.message;
    } catch (e) {
      return (e.toString());
    }
  }

  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _loginFormLoading = true;
    });

    // Run the create account method
    String? _loginFeedback = await _loginAccount();

    //If the string is not null we got error while create account
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);
    }

    //Set the form to regular state [Not Loading]
    setState(() {
      _loginFormLoading = false;
    });
  }

  bool _loginFormLoading = false;

  //Form Input Field Values
  String _loginEmail = '';
  String _loginPassword = '';

  // Focus Node for input fields
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                'Welcome User,\n Login to your account',
                textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hint: 'Email...',
                  onChanged: (value) {
                    _loginEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  hint: 'Password',
                  onChanged: (value) {
                    _loginPassword = value;
                  },
                  onSubmitted: (value) {
                    _submitForm();
                  },
                ),
                CustomBtn(
                  outLineBtn: false,
                  text: 'Login',
                  isLoading: _loginFormLoading,
                  onPressed: () {
                    _submitForm();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomBtn(
                outLineBtn: true,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                text: 'Create New Account',
              ),
            )
          ],
        ),
      ),
    ));
  }
}
