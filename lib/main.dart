import 'package:wallpaper/allExport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
void main() {

  runApp(MyApp());
  FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-4855672100917117~8276915157');

}
double x,y;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper Search',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
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
    );

  }
}
