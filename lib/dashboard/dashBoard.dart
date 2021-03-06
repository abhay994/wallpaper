
import 'dart:convert' as convert;
import '../allExport.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:launch_review/launch_review.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';


int cnt = 0;
class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}
 Color backgroundColor = Color(0xFFA3B1C6);
//Color(0xFFA3B1C6)
//Color(0xFF4A4A58)

class _MainDashboardState extends State<MainDashboard> with SingleTickerProviderStateMixin {
  Service _service = new Service();
  bool flag=true;
  String _colorName = "";
  String _catName = "";


  double screenWidth, screenHeight;

  List menuList ;
  List colorsList;
  List<Color> colors;
 // BannerAd myBanner;
AdWidget adWidget ;
  int rate;
  // List<Article> list;
  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate This App'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you love this app ?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Maybe Later',
                style: TextStyle(color: Colors.black26),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Rate Now'),
              onPressed: () {
                _assignRate();
                Future.delayed(Duration(seconds: 1), () {


                 // inAppReview.requestReview();

                  LaunchReview.launch(
                      androidAppId: "com.ar.free.wallpaper",
                      iOSAppId: "585027354");
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
  _loadrate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      rate = (prefs.getString('rate') ?? 0);
    });
  }

  _assignRate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(seconds: 2), () {
      prefs.setInt('rate', 1);
      rate = (prefs.getInt('rate'));
      print(rate);
    });
  }

  @override
  void initState() {

   // myBanner = BannerAd(
   //    adUnitId: 'ca-app-pub-4855672100917117/8837313274',
   //    size: AdSize.largeBanner,
   //    request: AdRequest(),
   //    listener: AdListener(),
   //  );
   //
   // Future.delayed(const Duration(seconds: 1), () {
   //   myBanner.load();
   //   adWidget  = AdWidget(ad: myBanner);
   // });

    _loadrate();
    Future.delayed(const Duration(seconds: 25), () {
      if (rate == 0) {
      _neverSatisfied();
      }
    });

    colorsList =["grey","red","orange","green","blue","white","black","brown","pink"];
    menuList = ["New","Backgrounds", "Fashion", "Nature", "Science", "Education", "Feelings", "Health", "People", "Religion", "Places", "Animals", "Industry", "Computer", "Food", "Sports", "Transportation", "Travel", "Buildings", "Business", "Music"];
    colors =[Colors.grey,Colors.red,Colors.orangeAccent,Colors.green,Colors.blueAccent,Colors.white,Colors.black,Colors.brown,Colors.pink];
    _service.initfetch();
    super.initState();

  }

  @override
  void dispose() {
    _service.disposeService();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[

            dashboards(context),
          ],
        ),
      ),
    );
  }



  Widget dashboards(context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      elevation: 8,
      color:backgroundColor,
      child: WallpaperList(_service.Popular)  ,
    );
  }

  Widget WallpaperList(var jsnStream) {
    return CustomScrollView(


              slivers: <Widget>[


                SliverList(

                  delegate: SliverChildListDelegate(

                      [
                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 10),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[

                              SizedBox(
                                height: screenHeight/25,
                              ),

                              Align(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: PorfileName(title: "Wallpaper Search",size: screenWidth*0.08,color: Colors.white,))),
                              SizedBox(
                                height: screenHeight/35,
                              ),
                              FittedBox(
                                  fit: BoxFit.contain,
                                  child: PorfileName(title: "Best Wallpaper For You",size: screenWidth*0.05,color: Colors.black,)),
                              SizedBox(
                                height: screenHeight/35,
                              ),
                              SearchBox(),
                              SizedBox(
                                height: screenHeight/35,
                              ),

                              FittedBox(
                                  fit: BoxFit.contain,
                                  child: PorfileName(title: "Popular",size: screenWidth*0.05,color: Colors.black,)),
                              SizedBox(
                                height: screenHeight/35,
                              ),


                            ],

                          ),),

                        sliderCaro(jsnStream),
                        SizedBox(
                          height: 20,
                        ),
                        menuLists(),
                        colorPlate(),
                        SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   alignment: Alignment.center,
                        //   child: adWidget,
                        //   width: myBanner.size.width.toDouble(),
                        //   height: myBanner.size.height.toDouble(),
                        // ),
                        SizedBox(
                          height: 10,
                        ),


                      ]),
                ),

                sliverG(_service.Wallpaperhd)

              ],
              scrollDirection: Axis.vertical,
            );

  }


  Widget sliderCaro(var _jsnStream){
    return StreamBuilder(stream: _jsnStream, builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> wallpaper = convert.jsonDecode(snapshot.data);
            var jsonResponse = wallpaper;
            print('yes');

           return CarouselSlider.builder(

             itemCount: jsonResponse['hits'].length as int !=null ?jsonResponse['hits'].length as int:0 ,

             options: CarouselOptions(
               height: MediaQuery
                   .of(context)
                   .size
                   .height *0.4,
               aspectRatio: 16 / 9,
               viewportFraction: 0.8,
               initialPage: 50,
               enableInfiniteScroll: true,
               reverse: true,
               autoPlay: true,
               autoPlayInterval: Duration(seconds: 3),
               autoPlayAnimationDuration: Duration(seconds: 1),
               autoPlayCurve: Curves.fastOutSlowIn,
             //  pauseAutoPlayOnTouch: Duration(seconds: 10),
               enlargeCenterPage: true,

             ),
             itemBuilder: (BuildContext context, int index, int realIndex) {
               return GestureDetector(
                     onTap: () {


                       Navigator.push(
                           context,
                           new MaterialPageRoute(
                               builder: (context) =>
                               new Detail(
                                   originalPic: jsonResponse['hits'][index]['largeImageURL'],
                                   pic: jsonResponse['hits'][index]['webformatURL'])));
//                                 Navigator.push(
//                                     context,
//                                     new MaterialPageRoute(
//                                         builder: (context) =>
//                                         new PictureView(
//                                             originalPic: jsonResponse['hits'][index]['largeImageURL'],
//                                             pic: jsonResponse['hits'][index]['webformatURL'])));
                     },
                     child: Neumorphic(
                       margin: EdgeInsets.all(5),
                       drawSurfaceAboveChild: true,
                       style: NeumorphicStyle(

                         shape: NeumorphicShape.convex,
                         intensity: 1,
                         depth: -15,
                         lightSource: LightSource.topLeft,


                       ),
                       boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),

                       child: Neumorphic(

                           margin: EdgeInsets.all(1),
                           boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                           child: Image.network(
                             jsonResponse['hits'][index]['webformatURL'],
                             fit: BoxFit.cover,
                             width: double.infinity,
                             height: double.infinity,
                           )

                       ),

                     ),
                   );

             },




//                height: MediaQuery
//                    .of(context)
//                    .size
//                    .height *0.4,
//                aspectRatio: 16 / 9,
//                viewportFraction: 0.8,
//                initialPage: 50,
//                enableInfiniteScroll: true,
//                reverse: true,
//                autoPlay: true,
//                autoPlayInterval: Duration(seconds: 3),
//                autoPlayAnimationDuration: Duration(seconds: 1),
//                autoPlayCurve: Curves.fastOutSlowIn,
//                pauseAutoPlayOnTouch: Duration(seconds: 10),
//                enlargeCenterPage: true,
//                itemCount: jsonResponse['hits'].length as int,
//                itemBuilder: (BuildContext context, int index) =>
//
//
//                    GestureDetector(
//                      onTap: () {
//
//
//                        Navigator.push(
//                            context,
//                            new MaterialPageRoute(
//                                builder: (context) =>
//                                new Detail(
//                                    originalPic: jsonResponse['hits'][index]['largeImageURL'],
//                                    pic: jsonResponse['hits'][index]['webformatURL'])));
// //                                 Navigator.push(
// //                                     context,
// //                                     new MaterialPageRoute(
// //                                         builder: (context) =>
// //                                         new PictureView(
// //                                             originalPic: jsonResponse['hits'][index]['largeImageURL'],
// //                                             pic: jsonResponse['hits'][index]['webformatURL'])));
//                      },
//                      child: Neumorphic(
//                        margin: EdgeInsets.all(5),
//                        drawSurfaceAboveChild: true,
//                        style: NeumorphicStyle(
//
//                          shape: NeumorphicShape.convex,
//                          intensity: 1,
//                          depth: -15,
//                          lightSource: LightSource.topLeft,
//
//
//                        ),
//                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
//
//                        child: Neumorphic(
//
//                            margin: EdgeInsets.all(1),
//                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
//                            child: Image.network(
//                              jsonResponse['hits'][index]['webformatURL'],
//                              fit: BoxFit.cover,
//                              width: double.infinity,
//                              height: double.infinity,
//                            )
//
//                        ),
//
//                      ),
//                    )


           );

          }else{

            return Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth:10 ,
                ),
              ),
            );
          }


    });

  }

  Widget sliverG(var _jsnStream) {


    return StreamBuilder(stream: _jsnStream,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData  && flag==true ) {
            Map<String, dynamic> wallpaper = convert.jsonDecode(snapshot.data);
            var jsonResponse = wallpaper;
            print('yes');

            return SliverGrid(

              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
                childAspectRatio: 0.75,
              ),

              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {

                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                              new Detail(
                                  originalPic: jsonResponse['hits'][index]['largeImageURL'],
                                  pic: jsonResponse['hits'][index]['webformatURL'])));

//                      Navigator.push(
//                          context,
//                          new MaterialPageRoute(
//                              builder: (context) =>
//                              new PictureView(
//                                  originalPic: jsonResponse['hits'][index]['largeImageURL'],
//                                  pic: jsonResponse['hits'][index]['webformatURL'],backColor: backgroundColor,)));

                    },

                    child: Neumorphic(
                      margin: EdgeInsets.all(5),
                      drawSurfaceAboveChild: true,
                      style: NeumorphicStyle(

                        shape: NeumorphicShape.convex,
                        intensity: 1,
                        depth: -15,
                        lightSource: LightSource.topLeft,


                      ),
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),

                      child: Neumorphic(

                          margin: EdgeInsets.all(1),
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                          child: Image.network(
                            jsonResponse['hits'][index]['webformatURL'],
                            fit: BoxFit.cover,
                            // width: double.infinity,
                            // height: double.infinity,
                          )

                      ),

                    ),

                  );
                },
                childCount: jsonResponse['hits'].length as int,
              ),
            ) ;



          }else{

            return SliverList(
                delegate: SliverChildListDelegate([

                 Container(
                   height: screenHeight/2,
                child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                strokeWidth:10 ,
                ),
            ),
          )

                ]));
          }


        });

  }

  Widget menuLists(){
    return Container(
      height: 40,

      width: screenWidth,
      child: ListView.builder(
          itemCount: menuList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            return Padding(
              padding: EdgeInsets.all(7),
              child: NeumorphicButton(
                  onClick: (){
                    cnt++;
                    print("click $cnt");
                    if(cnt%2==0) {
                      print("click addd");
                      _service.showAdmob();


                    }
                    _catName = menuList[index];
                    setState(() {
                      flag=false;

                    });
                    _service.httpReuests(query: menuList[index]=="New"?" ":menuList[index],colors: _colorName,order: "latest").whenComplete((){
                      setState(() {
                        flag=true;
                      });
                    });

                  },
                  padding: EdgeInsets.only(left: 10,right: 10),
                  margin: EdgeInsets.all(0),


                  style: NeumorphicStyle(

                      shape: NeumorphicShape.convex,

                      intensity: 0.5,
                      depth: 2

                  ),

                  child:Center(child: Text(menuList[index],style: TextStyle(color: Colors.black,fontSize: 10),))),
            );
          }),
    );

  }

  Widget colorPlate(){
    return Container(
      height: 50,

      width: screenWidth,
      child: ListView.builder(
          itemCount: colors.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            print(colors[index]);
            return Padding(
              padding: EdgeInsets.all(7),
              child: NeumorphicButton(

                margin: EdgeInsets.all(0),
                padding:EdgeInsets.all(0) ,

                style: NeumorphicStyle(

                    intensity: 0.4,
                    depth: 5


                ),
                child: Container(
                  height: 40,
                  width: 40,
                  color: colors[index],
                ),

                onClick: (){
                  cnt++;
                  if(cnt%4==0) {
                    print("click addd");
                    _service.showAdmob();


                  }
                  _colorName = colorsList[index];
                  setState(() {
                    flag=false;
                    backgroundColor = colors[index].withOpacity(0.7);

                  });
                  _service.httpReuests(query: _catName,colors: colorsList[index]).whenComplete((){
                    setState(() {
                      flag=true;
                    });
                  });

                  print(colorsList[index]);
                },
              ),

            );
          }),
    );

  }

}

