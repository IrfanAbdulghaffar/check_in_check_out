import 'package:check_in_check_out/utils/color_constants.dart';
import 'package:check_in_check_out/utils/helper_functions.dart';
import 'package:check_in_check_out/utils/shared_pref_instance.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/auth_service.dart';
import 'screens/home/check_in_check_out_screen.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreference.instance.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.dark,
  ));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Check In Check Out',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorConstants.primary,
        ),
        //primarySwatch: ColorConstants.primary,
        buttonTheme: ButtonTheme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: ColorConstants.primary,
            secondary: ColorConstants.primary, // Color you want for action buttons (CANCEL and OK)
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CheckInCheckOutScreen()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}