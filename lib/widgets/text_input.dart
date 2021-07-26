import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  TextEditingController controller;
  String hint;
  IconData icon;
  FormFieldValidator validator;
  TextInputType keyboardType;
  TextInputAction inputAction;
  FocusNode focusNode;
  FocusNode nextFocus;
  bool password;

  TextInput({
    this.controller,
    @required this.hint,
    this.icon,
    this.validator,
    this.keyboardType,
    this.inputAction,
    this.focusNode,
    this.nextFocus,
    this.password = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: password,
        keyboardType: keyboardType,
        textInputAction: inputAction,
        focusNode: focusNode,
        onFieldSubmitted: (String text) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
