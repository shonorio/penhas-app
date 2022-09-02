import 'package:asuka/asuka.dart' as asuka;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PenhaS',
      builder: asuka.builder,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Lato'),
      ),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      navigatorObservers: [
        observer,
        asuka.asukaHeroController,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
    ).modular();
  }
}