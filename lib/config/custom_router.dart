import 'package:flutter/material.dart';
import 'package:flutter_task/screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings){
print("Route : ${settings.name}");
switch(settings.name){
  case SplashScreen.routeName:
    return SplashScreen.route();
  case LoginScreen.routeName:
    return LoginScreen.route();
  case PluginScreen.routeName:
    return PluginScreen.route(arguments: settings.arguments as PluginScreen);
  case LastLoginScreen.routeName:
    return LastLoginScreen.route(arguments: settings.arguments as LastLoginScreen);
  default:
    return _errorRoute();
}
  }
  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: '/error'),
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Error Page')),
          ),
        ));
  }
}