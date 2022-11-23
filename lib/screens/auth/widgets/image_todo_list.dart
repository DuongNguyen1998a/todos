import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../responsive.dart';
import '../../../utils/helper.dart';

class ImageTodoList extends StatelessWidget {
  const ImageTodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: defaultPadding,
      ),
      child: Align(
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          width: Responsive.isMobile(context) ? 180 : 180 * 1.5,
          height: Responsive.isMobile(context) ? 160 : 160 * 1.5,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}