import 'package:bitcoin/bitcoin_connect_page.dart';
import 'package:bitcoin/home_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const BitcoinConnectPage());
      case 'home':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(
                  body: Center(
                      child:
                          Text('This route does not exist: ${settings.name}')),
                ));
    }
  }
}
