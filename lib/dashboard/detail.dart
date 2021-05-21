import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:wallpaper/service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:wallpaper_manager/wallpaper_manager.dart';



class Detail extends StatefulWidget {
  Detail({Key key, this.pic, this.originalPic}): super(key: key);


  final String pic;
  final String originalPic;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

Service _service = new Service();

  var filePath;
  String BASE64_IMAGE;
@override
  void initState() {


  print(widget.pic);
  print(widget.originalPic);
  _service.checkAndGetPermission();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double y = MediaQuery
        .of(context)
        .size
        .width;
    double x = MediaQuery
        .of(context)
        .size
        .height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        //       appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.white,
        //   leading: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.black,
        //   ),

        // ),

        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
//               color: Colors.black12,
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: new NetworkImage(
                    '${widget.pic}',
                  ),
                ),
              ),
            ),

            Center(child: CircularProgressIndicator()),
            FadeInImage.memoryNetwork(
              fadeInDuration: const Duration(seconds: 4),
              fadeInCurve: Curves.linearToEaseOut,
              placeholder: kTransparentImage,
              image: '${widget.originalPic}',
              fit: BoxFit.fill,
              width: y,
              height: x,
            ),


            Positioned(
              top:0,
              left:0,
              child:Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 40,
                  child: FloatingActionButton(

                      heroTag: "btn4",
                      tooltip: 'Close',

//    backgroundColor: widget.themeData.primaryColor,
                      child: Icon(
                        Icons.close,
                         size: 35,
//    color: widget.themeData.accentColor,
                      ),


                      onPressed: (){
                        Navigator.pop(context);
                  }),
                ),
              ),

            ),


            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(y / 5),
                        topRight: Radius.circular(y / 5))
                ),
                height: x / 15,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,

                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FloatingActionButton(
                        heroTag: "btn1",
                        tooltip: 'Set as Wallpaper',
//    backgroundColor: widget.themeData.primaryColor,
                        child: Icon(
                          Icons.wallpaper,
//    color: widget.themeData.accentColor,
                        ),
                        onPressed: () {

                          _onImageWallpapButtonPressed(widget.originalPic);
                        },
                      ),
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        heroTag: "btn2",
                        tooltip: 'Download',
//    backgroundColor: widget.themeData.primaryColor,
                        child: Icon(
                          Icons.file_download,
//    color: widget.themeData.accentColor,
                        ),
                        onPressed: () {

                            _onImageDownloadButtonPressed(widget.originalPic);


                        },
                      ),


                    ),
                    Expanded(
                      child: FloatingActionButton(
                        heroTag: "btn3",
                        tooltip: 'Share',
//    backgroundColor: widget.themeData.primaryColor,
                        child: Icon(
                          Icons.share,
//    color: widget.themeData.accentColor,
                        ),
                        onPressed: () {

                          _onImageShareButtonPressed(widget.originalPic);
                        },
                      ),

                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static const platform = const MethodChannel('wallpaper');

  // Future<void> _getWallpaper() async {
  //   try {
  //     final int result = await platform.invokeMethod(
  //         'getWallpaper', {"text": filePath});
  //      _onLoading(false,"Image is set as wallpaper...");
  //   } on PlatformException catch (e) {
  //     Navigator.pop(context);
  //   }
  // }


//share
  void _onImageShareButtonPressed(String URL) async {
   _onLoading(true,"Preparing image for Sharing...");
    print("_onImageSaveButtonPressed");
    var response = await http.get(URL);

   _onLoading(false,"Preparing image for Sharing...");
    print(filePath);
    BASE64_IMAGE = filePath;



   String _base64 = base64.encode(response.bodyBytes);


   _onLoading(false,"Preparing image for Sharing...");
   print(filePath);

    await Share.file('WallpaperSearch', 'wallpaperhub.png', base64.decode(_base64).buffer.asUint8List(), 'image/png',text: " We think it’s important that you can easily find inspiring and beautiful wallpapers that will make you happy and feel great every time you pick up your phone. Download Link(https://play.google.com/store/apps/details?id=com.ar.free.wallpaper)");
  }

//wallpaper
  void _onImageWallpapButtonPressed(String URL) async {
   _onLoading(true,"Preparing image for wallpaper...");
    print("_onImageSaveButtonPressed");
   // var response = await http.get(URL);
   // filePath = await ImagePickerSaver.saveFile(
   //     fileData: Uint8List.fromList(response.bodyBytes));
    print(filePath);
   int location = WallpaperManager.HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
  // String result;
   var file = await DefaultCacheManager().getSingleFile(URL);
   final String results = await WallpaperManager.setWallpaperFromFile(file.path, location);
   _onLoading(false,"Image is set as wallpaper...");


    //_getWallpaper();
  }


  void _onImageDownloadButtonPressed(String URL) async {
    _onLoading(true,"Preparing image for downloading...");
    print("_onImageSaveButtonPressed");
    var response = await http.get(URL);
     await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
    _onLoading(false,"Image is downloaded in gallery!");


  }

  void _onLoading(bool t,String status) {
    if(t) {
      showDialog(
          context: context,

          barrierDismissible: false,
          builder: (BuildContext context){
            return SimpleDialog(
              children: <Widget>[
                new Center(child: Column(children: <Widget>[
                  new CircularProgressIndicator(),
                  new Text(status),

                ],)),
                ],
            );
          });
    }else {
      Navigator.pop(context);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return SimpleDialog(
              children: <Widget>[

                  new Center(child: Column(children: <Widget>[
                  new Icon(Icons.check_circle,size:45 ,),
                  new Text(status),

                ],)),
              ],
            );
          });





      Future.delayed(Duration(seconds: 2),(){
        _service.showAdmob();
        Navigator.pop(context);


      });

    }
  }


}
