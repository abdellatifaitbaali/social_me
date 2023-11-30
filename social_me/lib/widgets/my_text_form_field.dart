import 'package:flutter/material.dart';
import 'package:social_me/utils/colors.dart';

class MTextFormField extends StatelessWidget {
  const MTextFormField({
    Key? key,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.obscureText = false,
    this.onSubmit,
    this.maxLines = 1,
    this.onChanged,
    this.hint = "",
    this.validator,
    this.prefix,
    this.prefixIcon,
    this.label,
    this.suffix,
    this.radius = 8.0,
    this.scrollController,
  }) : super(key: key);

  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool obscureText;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final int maxLines;
  final String hint;
  final Widget? prefix;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final Widget? label;
  final double radius;
  final Widget? suffix;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      scrollController: scrollController,
      obscuringCharacter: "●",
      textAlignVertical: TextAlignVertical.top,
      maxLines: maxLines,
      cursorColor: secondaryColor,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: mobileSearchColor,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.5,
            color: blueColor,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: mobileSearchColor,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: webBackgroundColor,
        contentPadding: const EdgeInsets.all(8),
      ),
      // decoration: InputDecoration(
      //   contentPadding: const EdgeInsets.all(8.0),
      //   fillColor: const Color(0XFFF2F2F2),
      //   filled: true,
      //   label: label,
      //   prefixIconConstraints: const BoxConstraints(),
      //   hintText: hint,
      //   prefix: prefix,
      //   prefixIcon: prefixIcon,
      //   suffixIcon: suffix,
      //   suffixIconConstraints: const BoxConstraints(),
      //   hintStyle: const TextStyle(color: Colors.grey),
      //   focusedBorder: OutlineInputBorder(
      //     borderSide: const BorderSide(
      //       color: Color(0XFF3EA6FF),
      //     ),
      //     borderRadius: BorderRadius.circular(radius),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderSide: BorderSide(
      //       color: Colors.grey[300]!,
      //     ),
      //     borderRadius: BorderRadius.circular(radius),
      //   ),
      //   errorBorder: OutlineInputBorder(
      //     borderSide: BorderSide(
      //       color: Colors.red[200]!,
      //     ),
      //     borderRadius: BorderRadius.circular(radius),
      //   ),
      //   focusedErrorBorder: OutlineInputBorder(
      //     borderSide: const BorderSide(
      //       color: Colors.red,
      //     ),
      //     borderRadius: BorderRadius.circular(radius),
      //   ),
      // ),
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
