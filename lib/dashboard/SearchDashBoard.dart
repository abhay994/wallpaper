import 'package:wallpaper/allExport.dart';
import 'dart:convert' as convert;
class SearchDashboard extends StatefulWidget {
  SearchDashboard({Key key,this.query}):super(key:key);
  String query;
   @override
  _SearchDashboardState createState() => _SearchDashboardState();

}

class _SearchDashboardState extends State<SearchDashboard> {
  Color backgroundColor = Color(0xFFA3B1C6);

  int cnts=0;
  Service _service = new Service();
  bool flag=true;
  String colorName = "";
  double screenWidth, screenHeight;

  List colorsList;
  List<Color> colors;
  @override
  void initState() {
    _service.showAdmob();
    setState(() {
      flag=false;
     // backgroundColor = colors[index].withOpacity(0.7);
    });
    _service.httpSearchReuests(query: widget.query).whenComplete((){
      setState(() {
        flag=true;
      });
    });
    colorsList =["grey","red","orange","green","blue","white","black","brown","pink"];
    colors =[Colors.grey,Colors.red,Colors.orangeAccent,Colors.green,Colors.blueAccent,Colors.white,Colors.black,Colors.brown,Colors.pink];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body:WallpaperList(_service.searchJson) ,

    );
  }


  Widget WallpaperList(var _jsnStream) {
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
                                height: screenHeight/20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[


                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: NeumorphicButton(

                                      minDistance: -2,
                                      onClick: (){

                                      Navigator.of(context).pop();
                                      },
                                      style: NeumorphicStyle(shape: NeumorphicShape.concave),

                                      boxShape: NeumorphicBoxShape.circle(),
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                  SizedBox(
                                    width:screenHeight/20,
                                  ),
                                  PorfileName(title: "Wallpaper Search",size:screenWidth/12,color: Colors.white,)

                                ],

                              ),



                            ],

                          ),),


                        SizedBox(
                          height: 20,
                        ),

                        colorPlate()


                      ]),
                ),

        sliverG(_jsnStream)

              ],
              scrollDirection: Axis.vertical,
            );

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
                      cnts++;
                      if(cnts%2==0) {
                        print("click addd");
                        _service.showAdmob();


                      }
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                              new Detail(
                                  originalPic: jsonResponse['hits'][index]['largeImageURL'],
                                  pic: jsonResponse['hits'][index]['webformatURL'])));

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
                        strokeWidth:10 ,
                      ),
                    ),
                  )

                ]));
          }


        });

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

                  colorName = colorsList[index];
                  setState(() {
                    flag=false;
                    backgroundColor = colors[index].withOpacity(0.7);

                  });
                  _service.httpSearchReuests(query: widget.query,colors: colorsList[index]).whenComplete((){
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
