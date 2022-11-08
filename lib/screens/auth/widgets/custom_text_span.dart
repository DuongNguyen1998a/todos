import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../responsive.dart';
import '../../../utils/colors.dart';

class CustomTextSpan extends StatelessWidget {
  final String text1;
  final String text2;

  const CustomTextSpan({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text1,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: Responsive.isMobile(context) ? 12 : 12 * 1.3,
          color: kBlackColor.withOpacity(0.5),
        ),
        children: [
          TextSpan(
            text: text2,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400,
              fontSize: Responsive.isMobile(context) ? 12 : 12 * 1.3,
              color: kOrangeColor,
            ),
          ),
        ],
      ),
    );
  }
}
