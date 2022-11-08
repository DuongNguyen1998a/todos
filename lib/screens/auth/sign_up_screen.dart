import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../responsive.dart';
import '../../utils/colors.dart';
import '../../utils/helper.dart';
import '../widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    key: signUpFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(defaultPadding,
                              defaultPadding * 1.5, defaultPadding, 16),
                          child: CustomTextField(
                            hintText: 'Email',
                            textController: emailController,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(defaultPadding,
                              0, defaultPadding, 16),
                          child: CustomTextField(
                            hintText: 'Full Name',
                            textController: fullNameController,
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
                          title: 'SIGN UP',
                          onPressed: () {

                          },
                        ),
                        CustomButton(
                          title: 'SIGN IN WITH GOOGLE',
                          onPressed: () {},
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/sign_in');
                            },
                            child: const CustomTextSpan(
                              text1: 'Have an account? ',
                              text2: 'Log in',
                            ),
                          ),
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
