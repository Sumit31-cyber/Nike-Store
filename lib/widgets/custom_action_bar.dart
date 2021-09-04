import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealuxe/screens/cart_page.dart';
import 'package:dealuxe/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomActionBar extends StatelessWidget {
  FirebaseServices _firebaseServices = FirebaseServices();

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('Users');

  final String? title;
  final bool? hasBackArrow;
  final bool? hasTitle;
  final bool? hasBackground;

  CustomActionBar(
      {this.title, this.hasBackArrow, this.hasTitle, this.hasBackground});

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? true;
    bool _hasBackground = hasBackground ?? true;
    return Container(
      decoration: BoxDecoration(
        gradient: _hasBackground
            ? LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0),
                ],
                begin: Alignment(0, 0),
                end: Alignment(0, 1),
              )
            : null,
      ),
      padding: EdgeInsets.only(top: 56, left: 24.0, right: 24.0, bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0)),
                width: 42,
                height: 42,
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage(
                    'assets/images/back_arrow.png',
                  ),
                  height: 16,
                  width: 16,
                ),
              ),
            ),
          if (_hasTitle)
            Text(
              title ?? "Action Bar",
              style: Constants.boldHeading,
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
            child: Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0)),
                child: StreamBuilder(
                  stream: _usersRef
                      .doc(_firebaseServices.getUserId())
                      .collection('Cart')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    int _totalItems = 0;

                    if (snapshot.connectionState == ConnectionState.active) {
                      List _document = snapshot.data!.docs;
                      _totalItems = _document.length;
                    }

                    return Text(
                      "$_totalItems",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
