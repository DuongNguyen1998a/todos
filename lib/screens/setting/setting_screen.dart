import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todos/utils/helper.dart';

import '../../providers/setting_provider.dart';
import '../../utils/colors.dart';
import '../widgets.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  void saveSetting() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              'When you change your app language, we auto close the app to apply change.',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: kOrangeColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<SettingProvider>().saveSetting();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    context.read<SettingProvider>().initLanguage();
    super.initState();
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications:',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: kBlackColor.withOpacity(0.5),
                  ),
                ),
                Consumer<SettingProvider>(builder: (context, provider, child) {
                  return Switch(
                    activeColor: kOrangeColor,
                    value: provider.notification,
                    onChanged: (val) {
                      provider.toggleNotification();
                    },
                  );
                }),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Languages:',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: kBlackColor.withOpacity(0.5),
                  ),
                ),
                Consumer<SettingProvider>(builder: (context, provider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      2,
                      (index) => GestureDetector(
                        onTap: () {
                          provider.onChangeLanguage(index, context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 16),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: provider.selected == index
                                ? kOrangeColor
                                : kBlackColor.withOpacity(0.5),
                          ),
                          child: Text(
                            provider.languages[index],
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                              color: provider.selected == index
                                  ? Colors.white
                                  : kBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          CustomButton(
            title: 'SAVE',
            onPressed: () {
              saveSetting();
            },
          ),
        ],
      ),
    );
  }
}
