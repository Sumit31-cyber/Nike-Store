import 'package:dealuxe/screens/product_page.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProductCard extends StatelessWidget {
  final Function()? onPressed;
  final String? imageUrl;
  final String? productId;
  final String? title;
  final String? price;

  ProductCard(
      {this.onPressed, this.imageUrl, this.title, this.price, this.productId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductPage(
                      productId: productId,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
        height: 350.0,
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  '$imageUrl',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title ?? 'Product Name',
                      style: Constants.regularHeading,
                    ),
                    Text(
                      price!,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
