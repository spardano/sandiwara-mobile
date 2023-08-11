import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/bottomNavbar.dart';
import 'package:easy_localization/easy_localization.dart';

// Dependencies
import 'package:firebase_core/firebase_core.dart';
import 'package:sandiwara/pages/loginPage.dart';
import 'package:sandiwara/pages/registerPage.dart';
import 'package:sandiwara/providers/article.dart';
import 'package:sandiwara/providers/auth.dart';
import 'package:sandiwara/utils/helpers.dart';
import '/firebase_options.dart'; // this file is generated by "flutterfire config" command
import 'package:firebase_messaging/firebase_messaging.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();

  await Firebase.initializeApp();

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
      startLocale: const Locale('id', 'ID'),
      path: 'lib/Screen/Integration/Language_Integration/language',
      child: const MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    FirebaseApi().initNotifications(context);
  }

  @override
  dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    ///Set color status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Article(),
        ),
      ],
      builder: (context, child) => GetMaterialApp(
        title: 'Sandiwara News',
        debugShowCheckedModeBanner: false,
        home: const bottomNavbar(),
        routes: {
          '/login/': (context) => const LoginPage(),
          '/register/': (context) => const registerPage(),
          '/home/': (context) => const bottomNavbar()
        },
      ),
    );
  }
}
