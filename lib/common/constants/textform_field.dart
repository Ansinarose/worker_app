
// // ignore_for_file: use_super_parameters

// import 'package:flutter/material.dart';

// class CustomTextFormField extends StatelessWidget {
//   final String labelText;
//   final TextEditingController controller;
//   final bool obscureText;
//   final String? Function(String?)? validator;
//   final IconData? prefixIcon;
//   final Color textColor;
//   final Color hintColor;
//   final Color borderColor;
//   final bool readOnly;
//   final VoidCallback? onTap;
//   final Widget? suffixIcon; // Add this line
 
//   const CustomTextFormField({
//     Key? key,
//     required this.labelText,
//     required this.controller,
//     this.obscureText = false,
//     this.validator,
//     this.prefixIcon,
//     this.textColor = const Color.fromARGB(255, 27, 12, 75),
//     this.hintColor = const Color.fromARGB(255, 27, 12, 75),
//     this.borderColor = const Color.fromARGB(255, 27, 12, 75),
//     this.readOnly = false,
//     this.onTap,
//     this.suffixIcon, // Add this line
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       readOnly: readOnly,
//       onTap: onTap,
//       decoration: InputDecoration(
//         labelText: labelText,
//         labelStyle: TextStyle(color: hintColor),
//         prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: hintColor) : null,
//         suffixIcon: suffixIcon, // Add this line
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: borderColor),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: borderColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       validator: validator,
//     );
//   }
// }
// custom_text_form_field.dart
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Color textColor;
  final Color hintColor;
  final Color borderColor;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.textColor = const Color.fromARGB(255, 27, 12, 75),
    this.hintColor = const Color.fromARGB(255, 27, 12, 75),
    this.borderColor = const Color.fromARGB(255, 27, 12, 75),
    this.readOnly = false,
    this.onTap,
    this.suffixIcon, 
    //required void Function(dynamic _) onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: hintColor),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: hintColor) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
