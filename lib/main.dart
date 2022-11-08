import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

/// providers
import 'providers/sign_in_provider.dart';
import 'providers/bottom_navigation_provider.dart';

/// screens
import 'screens/screens.dart';

/// colors
import 'utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(), // Wrap your app
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInProvider>(
          create: (_) => SignInProvider(),
        ),
        ChangeNotifierProvider<BottomNavigationProvider>(
          create: (_) => BottomNavigationProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Todo List',
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          scaffoldBackgroundColor: kWhiteColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/sign_in',
        routes: {
          '/sign_in': (context) => const SignInScreen(),
          '/sign_up': (context) => const SignUpScreen(),
          '/forgot_password': (context) => const ForgotPasswordScreen(),
          '/bottom_nav': (context) => const BottomNavigationScreen(),
        },
      ),
    );
  }
}
