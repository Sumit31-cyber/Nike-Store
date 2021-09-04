import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealuxe/constants.dart';
import 'package:dealuxe/services/firebase_services.dart';
import 'package:dealuxe/widgets/custom_input.dart';
import 'package:dealuxe/widgets/product_card.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchString.isEmpty)
            Center(
              child: Text(
                'Search Result',
                style: Constants.regularDarkText,
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productsRef
                  .orderBy('Search_string')
                  .startAt([_searchString]).endAt(
                      ['$_searchString\uf8ff']).get(),
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
                    padding: EdgeInsets.only(top: 128, bottom: 12),
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
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: CustomInput(
                hint: 'Search here...',
                onSubmitted: (value) {
                  setState(() {
                    _searchString = value.toLowerCase();
                  });
                }),
          ),
        ],
      ),
    );
  }
}
