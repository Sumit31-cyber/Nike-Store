import 'package:dealuxe/constants.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String? hint;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? isPasswordField;

  CustomInput(
      {this.hint,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPasswordField});

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      decoration: BoxDecoration(
          color: Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12.0)),
      child: TextField(
        obscureText: _isPasswordField,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted as dynamic,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 24)),
        style: Constants.regularDarkText,
      ),
    );
  }
}
