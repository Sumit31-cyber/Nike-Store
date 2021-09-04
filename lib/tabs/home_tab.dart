import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealuxe/constants.dart';
import 'package:dealuxe/screens/product_page.dart';
import 'package:dealuxe/widgets/custom_action_bar.dart';
import 'package:dealuxe/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productsRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error : ${snapshot.error}'),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: EdgeInsets.only(top: 108, bottom: 12),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ProductCard(
                      title: data['name'],
                      imageUrl: data['image'][0],
                      price: '\₹ ${data['price']}',
                      productId: document.id,
                    );
                  }).toList(),
                );
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF1E00)),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: false,
            title: 'Nike',
          ),
        ],
      ),
    );
  }
}
