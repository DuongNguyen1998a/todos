import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/sign_up_provider.dart';
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
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() {
    if (!signUpFormKey.currentState!.validate()) {
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Confirm password must be exactly password field.',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.redAccent,
            ),
          ),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } else {
      doSignUp(emailController.text, passwordController.text,
          fullNameController.text);
    }
  }

  Future<void> doSignUp(String email, password, fullName) async {
    try {
      // close keyboard
      FocusManager.instance.primaryFocus?.unfocus();
      // create user with email and password
      await context
          .read<SignUpProvider>()
          .signUpWithEmailAndPassword(email, password, fullName)
          .then(
        (value) {
          if (value == '200') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: kBlackColor,
                content: Text(
                  'Sign up successfully. please check your email to active account.',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ),
                ),
              ),
            );
            Navigator.pushNamed(context, '/sign_in');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: kBlackColor,
                content: Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: kRedColor,
                  ),
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ImageTodoList(),
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
                          padding: EdgeInsets.fromLTRB(
                              defaultPadding, 0, defaultPadding, 16),
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
                            child: Consumer<SignUpProvider>(
                                builder: (context, provider, child) {
                              final hidePassword = provider.hidePassword;
                              return CustomTextField(
                                textController: passwordController,
                                hintText: 'Password',
                                obscureText: hidePassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    provider.togglePassword();
                                  },
                                  icon: Icon(
                                    hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              );
                            }),
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
                            child: Consumer<SignUpProvider>(
                                builder: (context, provider, child) {
                              final hideConfirmPassword =
                                  provider.hideConfirmPassword;
                              return CustomTextField(
                                textController: confirmPasswordController,
                                hintText: 'Confirm Password',
                                obscureText: hideConfirmPassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    provider.toggleConfirmPassword();
                                  },
                                  icon: Icon(
                                    hideConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                              );
                            }),
                          ),
                        ),
                        Consumer<SignUpProvider>(
                          builder: (context, provider, child) {
                            final isLoading = provider.isLoading;
                            return isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: kOrangeColor,
                                    ),
                                  )
                                : CustomButton(
                                    title: 'SIGN UP',
                                    onPressed: () {
                                      signUp();
                                    },
                                  );
                          },
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