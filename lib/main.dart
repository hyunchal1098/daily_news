import 'package:daily_news/screen/detail_screen.dart';
import 'package:daily_news/screen/main_screen.dart';
import 'package:daily_news/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily News',
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => SplashScreen(),
        "/main": (context) => MainScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/detail") {
          dynamic newsItem = settings.arguments as dynamic;
          return MaterialPageRoute(
            builder: (context) {
              return DetailScreen(newsItem: newsItem);
            },
          );
        }
      },
    );
  }
}
