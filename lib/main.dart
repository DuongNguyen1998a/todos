import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos/local_db/todo_database.dart';
import 'package:todos/providers/change_password_provider.dart';
import 'package:todos/providers/home_provider.dart';
import 'package:todos/providers/setting_provider.dart';

import 'firebase_options.dart';

/// providers
import 'providers/sign_up_provider.dart';
import 'providers/sign_in_provider.dart';
import 'providers/forgot_password_provider.dart';
import 'providers/bottom_navigation_provider.dart';
import 'providers/profile_provider.dart';

/// screens
import 'screens/screens.dart';

/// colors
import 'utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => // Wrap your app
      // ),
      EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('vi', 'VI')],
        path: 'assets/translations', // <-- change the path of the translation files
        //fallbackLocale: Locale('en', 'US'),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  late StreamSubscription<User?> user;
  late Locale locale;

  void initState() {
    super.initState();
    locale = Locale('en', 'US');

    user = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        final prefs = await SharedPreferences.getInstance();
        if (prefs.get('LANGUAGE') != null) {
          if (prefs.get('LANGUAGE') == 'vi') {
            setState(() {
              locale = Locale('vi');
            });
          }
          else {
            setState(() {
              locale = Locale('en', 'US');
            });
          }
        }
       }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignUpProvider>(
          create: (_) => SignUpProvider(),
        ),
        ChangeNotifierProvider<SignInProvider>(
          create: (_) => SignInProvider(),
        ),
        ChangeNotifierProvider<ForgotPasswordProvider>(
          create: (_) => ForgotPasswordProvider(),
        ),
        ChangeNotifierProvider<BottomNavigationProvider>(
          create: (_) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider<ChangePasswordProvider>(
          create: (_) => ChangePasswordProvider(),
        ),
        ChangeNotifierProvider<SettingProvider>(
          create: (_) => SettingProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: locale,
        title: 'Todo List',
        theme: ThemeData(
          scaffoldBackgroundColor: kWhiteColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? '/sign_in'
            : '/bottom_nav',
        routes: {
          '/sign_in': (context) => const SignInScreen(),
          '/sign_up': (context) => const SignUpScreen(),
          '/forgot_password': (context) => const ForgotPasswordScreen(),
          '/bottom_nav': (context) => const BottomNavigationScreen(),
          '/change_password': (context) => const ChangePasswordScreen(),
          '/setting': (context) => const SettingScreen(),
          '/todo_detail': (context) => const TodoDetailScreen(),
        },
      ),
    );
  }
}
