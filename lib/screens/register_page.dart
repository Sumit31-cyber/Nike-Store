import 'package:dealuxe/screens/login_page.dart';
import 'package:dealuxe/widgets/custom_btn.dart';
import 'package:dealuxe/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  Future<String?> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
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
      _registerFormLoading = true;
    });

    // Run the create account method
    String? _createAccountFeedback = await _createAccount();

    //If the string is not null we got error while create account
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);
    } else {
      Navigator.pop(context);
    }

    //Set the form to regular state [Not Loading]
    setState(() {
      _registerFormLoading = false;
    });
  }

  bool _registerFormLoading = false;

  //Form Input Field Values
  String _registerEmail = '';
  String _registerPassword = '';

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
                'Create A New Account',
                textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hint: 'Email...',
                  onChanged: (value) {
                    _registerEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  onChanged: (value) {
                    _registerPassword = value;
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  hint: 'Password',
                  onSubmitted: (value) {
                    _submitForm();
                  },
                ),
                CustomBtn(
                  outLineBtn: false,
                  text: 'Create New Account',
                  isLoading: _registerFormLoading,
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
                  Navigator.pop(context);
                },
                text: 'Back To Login',
              ),
            )
          ],
        ),
      ),
    ));
  }
}
