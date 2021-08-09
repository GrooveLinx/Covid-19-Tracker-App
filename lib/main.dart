import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:covid19_app/pages/404-page.dart';
import 'package:covid19_app/pages/home-page.dart';
import 'package:covid19_app/provider/covid-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // needs to be called because run app isn't called first
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of our application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isConnected = false;
  StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = Connectivity().onConnectivityChanged.listen(
      (event) {
        setState(
          () {
            isConnected = (event != ConnectivityResult.none);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CovidDataProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Covid19 App',
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: isConnected ? HomePage() : ErrorPage(),
      ),
    );
  }
}
