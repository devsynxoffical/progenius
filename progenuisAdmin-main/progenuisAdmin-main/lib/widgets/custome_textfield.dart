import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText; // Add obscureText parameter

  const CustomTextField({
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false, // Default value for obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText, // Use the obscureText parameter here
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.purple),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }
}
