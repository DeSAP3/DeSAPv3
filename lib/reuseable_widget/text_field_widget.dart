import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextInputType? textInputType;
  final String hintText;
  final String? labelText;
  final bool? obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;

  const TextFieldWidget(
      {super.key,
      this.textInputType,
      required this.hintText,
      this.labelText,
      this.obscureText,
      required this.controller,
      this.validator,
      this.prefixIcon,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextFormField(
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 252, 242, 242),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.7)
            ),
            labelText: labelText,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(15)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(15)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon),
        obscureText: obscureText ?? false,
        controller: controller,
        keyboardType: textInputType,
      ),
    );
  }
}
