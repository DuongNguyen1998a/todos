import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/sign_in_provider.dart';
import '../../responsive.dart';

/// colors
import '../../utils/colors.dart';

/// helpers
import '../../utils/helper.dart';
import '../widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<SignInProvider>().resetScreenState();
    });
    super.initState();
  }

  void signIn() {
    if (!signInFormKey.currentState!.validate()) {
      return;
    } else {
      doSignIn(emailController.text, passwordController.text);
    }
  }

  Future<void> doSignIn(String email, password) async {
    try {
      // close keyboard
      FocusManager.instance.primaryFocus?.unfocus();
      // sign in with email and password
      await context
          .read<SignInProvider>()
          .signInWithEmailAndPassword(email, password)
          .then(
        (value) {
          if (value == '200') {
            Navigator.pushReplacementNamed(context, '/bottom_nav');
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

  void googleSignIn() {
    debugPrint('Google sign in');
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                    key: signInFormKey,
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
                              defaultPadding, 0, defaultPadding, 15),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: kOrangeColor,
                                  ),
                            ),
                            child: Consumer<SignInProvider>(
                              builder: (context, provider, child) {
                                return CustomTextField(
                                  textController: passwordController,
                                  hintText: 'Password',
                                  obscureText: provider.obscureText,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      provider.toggleObscureText();
                                    },
                                    icon: provider.obscureText
                                        ? const Icon(
                                            Icons.visibility_off,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                          ),
                                  ),
                                  textInputAction: TextInputAction.done,
                                );
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 24, 16),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/forgot_password');
                              },
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.montserrat(
                                  fontSize: Responsive.isMobile(context)
                                      ? 12
                                      : 12 * 1.3,
                                  fontWeight: FontWeight.w400,
                                  color: kBlackColor.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Consumer<SignInProvider>(
                            builder: (context, provider, child) {
                          final isLoading = provider.isLoading;
                          return isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: kOrangeColor,
                                  ),
                                )
                              : CustomButton(
                                  title: 'SIGN IN',
                                  onPressed: () {
                                    signIn();
                                  },
                                );
                        }),
                        CustomButton(
                          title: 'SIGN IN WITH GOOGLE',
                          onPressed: () {},
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/sign_up');
                            },
                            child: const CustomTextSpan(
                              text1: 'Don\'t have an account? ',
                              text2: 'Sign Up',
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
