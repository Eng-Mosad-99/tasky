import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_tasky/core/helper/app_colors.dart';
import 'build_border.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.suffixIcon,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.hntText,
    this.maxLines,
    this.prefixIcon,
    this.hintStyle,
    this.validator,
    this.autovalidateMode,
  });
  final Widget? suffixIcon, prefixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hntText;
  final TextStyle? hintStyle;
  final int? maxLines;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextFormField(
        autovalidateMode: autovalidateMode,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: 16.0.sp,
        ),
        obscureText: obscureText,
        obscuringCharacter: '*',
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          hintText: hntText,
          hintStyle: hintStyle,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding: EdgeInsets.only(
            left: 12.sp,
            right: 12.sp,
            bottom: 8.sp,
          ),
          focusedBorder: buildBorder(),
          enabledBorder: buildBorder(),
          errorBorder: buildBorder(Colors.red),
          border: buildBorder(),
        ),
      ),
    );
  }
}
