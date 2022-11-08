import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
/// responsive
import '../../../responsive.dart';
/// colors
import '../../../utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputAction textInputAction;
  final TextEditingController textController;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.suffixIcon,
    this.obscureText,
    this.textInputAction = TextInputAction.next,
    required this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      style: GoogleFonts.montserrat(
        fontSize: Responsive.isMobile(context) ? 16 : 16 * 1.3,
        fontWeight: FontWeight.w400,
        color: kBlackColor,
      ),
      cursorColor: kOrangeColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 16),
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
          fontSize: Responsive.isMobile(context) ? 16 : 16 * 1.3,
          fontWeight: FontWeight.w400,
          color: kBlackColor.withOpacity(0.5),
        ),
        errorStyle: GoogleFonts.montserrat(
          fontSize: Responsive.isMobile(context) ? 14 : 14 * 1.3,
          fontWeight: FontWeight.w400,
          color: Colors.redAccent,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kBlackColor.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kBlackColor.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kBlackColor.withOpacity(0.5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kBlackColor.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kBlackColor.withOpacity(0.5),
          ),
        ),
        suffixIcon: suffixIcon ?? const SizedBox.shrink(),
      ),
      obscureText: obscureText ?? false,
      textInputAction: textInputAction,
      validator: (String? val) {
        if (val!.isEmpty) {
          return '$hintText is not empty.';
        }
        return null;
      },
    );
  }
}
