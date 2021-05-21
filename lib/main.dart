import 'package:wallpaper/allExport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
  //MobileAds.instance.initialize(appId: 'ca-app-pub-4855672100917117~8276915157');
  WidgetsFlutterBinding.ensureInitialized();


}
double x,y;

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Wallpaper Search',
    //   theme: ThemeData(
    //
    //     primarySwatch: Colors.blue,
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   home:NeumorphicTheme(
    //       usedTheme: UsedTheme.LIGHT,
    //       theme: NeumorphicThemeData(
    //         baseColor: Color(0xFFE0E5EC),
    //         intensity: 0.5,
    //         lightSource: LightSource.topLeft,
    //         depth: 10,
    //       ),
    //       darkTheme: NeumorphicThemeData(
    //         baseColor: Color(0xFF000000),
    //         intensity: 0.5,
    //         lightSource: LightSource.topLeft,
    //         depth: 10,
    //       ),
    //       child: MainDashboard()) ,
    // );

    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 480,

          defaultScale: true,


          breakpoints: [
//            ResponsiveBreakpoint.autoScale(600,name: MOBILE),
//
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(  decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFCBCDFA), Color(0xFFD2ACD3)],
                tileMode: TileMode.clamp,
                begin: Alignment.topCenter,
                stops: [0.0, 1.0],
                end: Alignment.bottomCenter),
          ),)
      ),
        home:NeumorphicTheme(
            usedTheme: UsedTheme.LIGHT,
            theme: NeumorphicThemeData(
              baseColor: Color(0xFFE0E5EC),
              intensity: 0.5,
              lightSource: LightSource.topLeft,
              depth: 10,
            ),
            darkTheme: NeumorphicThemeData(
              baseColor: Color(0xFF000000),
              intensity: 0.5,
              lightSource: LightSource.topLeft,
              depth: 10,
            ),
            child: MainDashboard()) ,

      //  theme: Theme.of(context).copyWith(platform: TargetPlatform.android),
      debugShowCheckedModeBanner: false,
    );

  }
}
