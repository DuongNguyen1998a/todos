import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todos/providers/bottom_navigation_provider.dart';

import '../../providers/change_password_provider.dart';
import '../../responsive.dart';
import '../../utils/colors.dart';
import '../../utils/helper.dart';
import '../widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void changePassword() {
    if (!changePasswordFormKey.currentState!.validate()) {
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kBlackColor,
          content: Text(
            'Confirm Password mus be exactly password field.',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: kRedColor,
            ),
          ),
        ),
      );
    } else {
      doChangePassword(passwordController.text);
    }
  }

  Future<void> doChangePassword(String password) async {
    try {
      await context
          .read<ChangePasswordProvider>()
          .changePassword(password)
          .then(
        (value) {
          if (value == '200') {
            context.read<ChangePasswordProvider>().resetScreenState();
            context.read<BottomNavigationProvider>().onChangeScreen(0);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: kBlackColor,
                content: Text(
                  'Change password success, please sign in again with new password.',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: kOrangeColor,
                  ),
                ),
              ),
            );
            Navigator.pushReplacementNamed(context, '/sign_in');
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
                    key: changePasswordFormKey,
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
                            child: Consumer<ChangePasswordProvider>(
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
                            child: Consumer<ChangePasswordProvider>(
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
                        Consumer<ChangePasswordProvider>(
                          builder: (context, provider, child) {
                            final isLoading = provider.isLoading;
                            return isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: kOrangeColor,
                                    ),
                                  )
                                : CustomButton(
                                    title: 'CHANGE PASSWORD',
                                    onPressed: () {
                                      changePassword();
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
