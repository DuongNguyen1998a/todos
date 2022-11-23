import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/forgot_password_provider.dart';
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
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> forgotPassFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void resetPassword() {
    if (!forgotPassFormKey.currentState!.validate()) {
      return;
    }  else {
      doResetPassword(emailController.text);
    }
  }

  Future<void> doResetPassword(String email) async {
    try {
      // close keyboard
      FocusManager.instance.primaryFocus?.unfocus();
      // forgot password
      await context
          .read<ForgotPasswordProvider>()
          .resetPassword(email)
          .then(
        (value) {
          if (value == '200') {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: kBlackColor,
                content: Text(
                  'Reset password successfully. Please check email to reset password',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ),
                ),
              ),
            );
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
        ),
      ),
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
                            child: Consumer<ForgotPasswordProvider>(
                                builder: (context, provider, child) {
                              return CustomTextField(
                                textController: emailController,
                                hintText: 'Email',
                              );
                            }),
                          ),
                        ),
                        Consumer<ForgotPasswordProvider>(
                          builder: (context, provider, child) {
                            final isLoading = provider.isLoading;
                            return isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: kOrangeColor,
                                    ),
                                  )
                                : CustomButton(
                                    title: 'RESET PASSWORD',
                                    onPressed: () {
                                      resetPassword();
                                    },
                                  );
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

class _ImageTodoList extends StatelessWidget {
  const _ImageTodoList({Key? key}) : super(key: key);

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
