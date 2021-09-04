import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String? text;
  final Function()? onPressed;
  final bool? outLineBtn;
  final bool? isLoading;
  CustomBtn({this.text, this.onPressed, this.outLineBtn, this.isLoading});

  @override
  Widget build(BuildContext context) {
    bool _outlineBtn = outLineBtn ?? false;
    bool _isLoading = isLoading ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        height: 65.0,
        decoration: BoxDecoration(
          color: _outlineBtn ? Colors.transparent : Colors.black,
          border: Border.all(
            width: 2.0,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Visibility(
              visible: _isLoading ? false : true,
              child: Center(
                child: Text(
                  text ?? 'Text',
                  style: TextStyle(
                      color: _outlineBtn ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator())),
            ),
          ],
        ),
      ),
    );
  }
}
