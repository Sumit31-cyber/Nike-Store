import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealuxe/constants.dart';
import 'package:dealuxe/services/firebase_services.dart';
import 'package:dealuxe/widgets/custom_action_bar.dart';
import 'package:dealuxe/widgets/image_swipe.dart';
import 'package:dealuxe/widgets/product_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  late final String? productId;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _selectedProductSize = '0';

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection('Cart')
        .doc(widget.productId)
        .set({'size': _selectedProductSize});
  }

  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection('Saved')
        .doc(widget.productId)
        .set({'size': _selectedProductSize});
  }

  final SnackBar _snackBar = SnackBar(content: Text('Product added to Cart'));
  final SnackBar _snackBarSaved =
      SnackBar(content: Text('Product added to Saved'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(widget.productId).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error : ${snapshot.error}'),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> documentData =
                    snapshot.data!.data() as Map<String, dynamic>;

                List imageList = documentData['image'];
                List productSize = documentData['size'];

                _selectedProductSize = productSize[0];
                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: imageList,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 4, top: 24),
                      child: Text(
                        documentData['name'] ?? 'Product Name',
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 24),
                      child: Text(
                        '\₹ ${documentData['price']}',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      child: Text(
                        documentData['desc'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 24),
                      child: Text(
                        'Select Size',
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: productSize,
                      onSelected: (size) {
                        _selectedProductSize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(_snackBarSaved);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                  color: Color(0xFFDCDCDC),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Image(
                                image: AssetImage(
                                  'assets/images/tab_saved.png',
                                ),
                                height: 21,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 16),
                                alignment: Alignment.center,
                                height: 65.0,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  'Add To Cart',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
