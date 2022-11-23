import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todos/providers/bottom_navigation_provider.dart';
import 'package:todos/providers/profile_provider.dart';
import 'package:todos/utils/helper.dart';

import '../../utils/colors.dart';
import '../auth/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchUserProfile();
    });
    super.initState();
  }

  Future<void> logOut() async {
    try {
      context.read<ProfileProvider>().logOut().then((_) {
        context.read<BottomNavigationProvider>().onChangeScreen(0);
        Navigator.pushReplacementNamed(context, '/sign_in');
      },);
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        title: Text(
          'TO DO LIST',
          style: GoogleFonts.bebasNeue(
            fontWeight: FontWeight.bold,
            color: kOrangeColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
            icon: Icon(
              Icons.settings_outlined,
              color: kBlackColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/profile.svg',
                width: 326,
                height: 243,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Full Name',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Consumer<ProfileProvider>(
                          builder: (context, provider, child) {
                            return Expanded(
                              child: Text(
                                provider.userProfile != null
                                    ? provider.userProfile!.fullName
                                    : 'Loading full name',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kOrangeColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Consumer<ProfileProvider>(
                          builder: (context, provider, child) {
                            return Expanded(
                              child: Text(
                                provider.userProfile != null
                                    ? provider.userProfile!.email
                                    : 'Loading email',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kOrangeColor,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Password',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor.withOpacity(0.5),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/change_password');
                          },
                          child: Text(
                            'Change password',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: kOrangeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    onPressed: () {
                      logOut();
                    },
                    title: 'LOG OUT',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
