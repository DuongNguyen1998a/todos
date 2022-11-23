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
  final int maxLines;
  final Color cursorColor;
  final Color hintColor;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.suffixIcon,
    this.obscureText,
    this.textInputAction = TextInputAction.next,
    required this.textController,
    this.maxLines = 1,
    this.cursorColor = kOrangeColor,
    this.hintColor = kBlackColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: textController,
      style: GoogleFonts.montserrat(
        fontSize: Responsive.isMobile(context) ? 16 : 16 * 1.3,
        fontWeight: FontWeight.w400,
        color: hintColor,
      ),
      cursorColor: cursorColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 16, top: maxLines > 1 ? 32 : 0),
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
          fontSize: Responsive.isMobile(context) ? 16 : 16 * 1.3,
          fontWeight: FontWeight.w400,
          color: hintColor.withOpacity(0.5),
        ),
        errorStyle: GoogleFonts.montserrat(
          fontSize: Responsive.isMobile(context) ? 14 : 14 * 1.3,
          fontWeight: FontWeight.w400,
          color: Colors.redAccent,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hintColor.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hintColor.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hintColor.withOpacity(0.5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hintColor.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hintColor.withOpacity(0.5),
          ),
        ),
        suffixIcon: suffixIcon ?? const SizedBox.shrink(),
      ),
      obscureText: obscureText ?? false,
      textInputAction: textInputAction,
      validator: (String? val) {
        if (val!.isEmpty) {
          return '$hintText is not empty.';
        } else if (hintText == 'Password' && val.length <= 6) {
          return '$hintText must be > 6 characters';
        }
        else if (hintText == 'Confirm Password' && val.length <= 6) {
          return '$hintText must be > 6 characters';
        }
        return null;
      },
    );
  }
}
