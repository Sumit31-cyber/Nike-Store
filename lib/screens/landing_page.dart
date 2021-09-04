import 'package:dealuxe/constants.dart';
import 'package:dealuxe/screens/home_page.dart';
import 'package:dealuxe/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // If snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: Constants.regularHeading,
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Error: ${streamSnapshot.error}',
                      style: Constants.regularHeading,
                    ),
                  ),
                );
              }
              if (streamSnapshot.connectionState == ConnectionState.active) {
                Object? _user = streamSnapshot.data;
                if (_user == null) {
                  return LoginPage();
                } else {
                  return Homepage();
                }
              }

              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
