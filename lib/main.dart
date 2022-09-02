import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:penhas/app/app_module.dart';
import 'package:penhas/app/app_widget.dart';

const _kTestingCrashlytics = false;

Future main({String? apiBaseUrlOverride}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Pass all uncaught errors from the framework to Crashlytics.
  FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(_kTestingCrashlytics || !kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded(
    () async {
      runApp(
        ModularApp(
          module: AppModule(apiBaseUrl: apiBaseUrlOverride),
          child: AppWidget(),
        ),
      );
    },
    FirebaseCrashlytics.instance.recordError,
  );
}