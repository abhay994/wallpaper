import 'package:wallpaper/allExport.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchQuery = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
   double screenHeight = size.height;
    double screenWidth = size.width;
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        intensity: 1,
        depth: -6,
        lightSource: LightSource.topLeft,
      ) ,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
      child: Container(

        width: screenWidth,
        height: screenHeight/11,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child:TextField(

                    controller: _searchQuery,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration.collapsed(hintText: "Search Wallpaper"),
                  onSubmitted: (value){

                      print(value);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                              new SearchDashboard(query: value)));
                  },


//                    decoration: InputDecoration(
//
//                      contentPadding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 10),
//                      hintText: "Search For Wallpapers",
//
//                    )
                ) ,
              ),

            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                          new SearchDashboard(query: _searchQuery.text)));

                },
              splashColor: Colors.black,
                child: Icon(Icons.search,size: 30,),
              ),

            ),
          ],
        ),
      ),
    );
  }









}