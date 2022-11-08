import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../responsive.dart';
import '../../../utils/colors.dart';
import '../../../utils/helper.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 16),
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kOrangeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: Responsive.isMobile(context) ? 14 : 14 * 1.3,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
