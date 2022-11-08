import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../responsive.dart';
import '../../utils/colors.dart';
import '../../utils/helper.dart';
import '../widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> forgotPassFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: kBlackColor,),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
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
            ),
            Expanded(
              child: Align(
                alignment:
                !Responsive.isMobile(context) && getWidth(context) >= 800
                    ? Alignment.center
                    : Alignment.bottomCenter,
                child: SizedBox(
                  width: !Responsive.isMobile(context) ? 600 : double.infinity,
                  child: Form(
                    key: forgotPassFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              defaultPadding, 0, defaultPadding, 15),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                primary: kOrangeColor,
                              ),
                            ),
                            child: CustomTextField(
                              textController: passwordController,
                              hintText: 'Password',
                              obscureText: true,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              defaultPadding, 0, defaultPadding, 15),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                primary: kOrangeColor,
                              ),
                            ),
                            child: CustomTextField(
                              textController: passwordController,
                              hintText: 'Confirm Password',
                              obscureText: true,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.visibility_off,
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                        CustomButton(
                          title: 'CHANGE PASSWORD',
                          onPressed: () {

                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
