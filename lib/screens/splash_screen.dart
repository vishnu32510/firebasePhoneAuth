import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/screens/login_screen.dart';
import 'package:flutter_task/services/services.dart';
import 'package:lottie/lottie.dart';
class SplashScreen extends StatefulWidget {
  static const String routeName = '/splashScreen';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => SplashScreen());
  }

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    currentUser();
  }

  Future currentUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await addLoginDetails(context: context);

      // return true;
    } else {
      print("No current user");
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushNamedAndRemoveUntil(
          LoginScreen.routeName, (Route<dynamic> route) => false,
          arguments: LoginScreen());
      // return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset('assets/lottie/89166-splash.json'),
    );
  }
}
