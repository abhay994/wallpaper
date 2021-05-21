import 'package:http/http.dart' as http;
import 'dart:math';
import 'Key.dart';
import 'package:rxdart/rxdart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'allExport.dart';




class Service{
  String initialUrl = '';
  BehaviorSubject<String> Popular;
  BehaviorSubject<String> WallpaperUrl;

  BehaviorSubject<String> Wallpaperhd;

  BehaviorSubject<String> Search;
  Random random;
  InterstitialAd _interstitialAd;
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-4855672100917117/9408929779',
     // adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
      listener: AdListener(),
      //  targetingInfo: targetingInfo,
      // listener: (MobileAdEvent event) {
      //   print("InterstitialAd event $event");
      // },
    );
  }
  Service({this.initialUrl}){

    Popular = new BehaviorSubject<String>.seeded(this.initialUrl);

    random = new Random();
    Search = new BehaviorSubject<String>.seeded(this.initialUrl);
    WallpaperUrl = new BehaviorSubject<String>.seeded(this.initialUrl);

    Wallpaperhd = new BehaviorSubject<String>.seeded(this.initialUrl);




  }
  Stream<String> get PopularJson => Popular.stream;
  Stream<String> get wallpaperJson => WallpaperUrl.stream;
  Stream<String> get wallpaperhdJson => Wallpaperhd.stream;
  Stream<String> get searchJson=> Search.stream;




  void initfetch( ) async {
  //  _interstitialAd = createInterstitialAd()..load();
print('fetch');
   httpReuest(query: "").then((value) {
     Popular.sink.add(value);

    });

  httpReuest(query: "",order: "latest").then((value) {
     Wallpaperhd.sink.add(value);

});



  }

  void showAdmob() async{
    _interstitialAd = createInterstitialAd()..load()..show();


  }





 Future<String> httpReuest({String query,String order,String orientation,String colors,String category}) async{
 //  random.nextInt(2)
    var URL= 'https://pixabay.com/api/?key=${apiKey[random.nextInt(4)]}&q=$query&image_type=photo&per_page=200&order=$order&orientation=$orientation&colors=$colors&category=$category&safesearch=true';
    var response = await http.get(URL);
    if (response.statusCode == 200) {
     print(response.body);
      return response.body;

    } else {
   print('Request failed status: ${response.statusCode}.');
   }

  }

  Future<void> httpReuests({String query,String order,String orientation,String colors,String category}) async{

    httpReuest(query: query,order: order,orientation: orientation,colors: colors,category: category).then((value) {
      Wallpaperhd.sink.add(value);

    });
 // print("inRequest");
 //    //   Wallpaperhd = new BehaviorSubject<String>.seeded(this.initialUrl);
 //    //Wallpaperhd.sink.add('[]');
 //    var URL= 'https://pixabay.com/api/?key=${apiKey[random.nextInt(3)]}&q=${query}&image_type=photo&per_page=200&order=${order}&orientation=${orientation}&colors=${colors}&category=${category}&safesearch=true';
 //    var response = await http.get(URL);
 //    if (response.statusCode == 200) {
 //      print(response.body);
 //
 //      Wallpaperhd.sink.add(response.body);
 //
 //    } else {
 //      print('Request failed status: ${response.statusCode}.');
 //    }

  }



  Future<void> httpSearchReuests({String query,String order,String orientation,String colors,String category}) async{

    httpReuest(query: query,order: order,orientation: orientation,colors: colors,category: category).then((value) {
      Search.sink.add(value);

    });


    // print("inRequest");
    // //   Wallpaperhd = new BehaviorSubject<String>.seeded(this.initialUrl);
    // //Wallpaperhd.sink.add('[]');
    // var URL= 'https://pixabay.com/api/?key=${apiKey[random.nextInt(3)]}&q=${query}&image_type=photo&per_page=200&order=${order}&orientation=${orientation}&colors=${colors}&category=${category}&safesearch=true';
    // var response = await http.get(URL);
    // if (response.statusCode == 200) {
    //   print(response.body);
    //   Search.sink.add(response.body);
    //
    // } else {
    //   print('Request failed status: ${response.statusCode}.');
    // }



  }


  Future<bool> checkAndGetPermission() async{
    final PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      final Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions(<PermissionGroup>[PermissionGroup.storage]);
      if(permissions[PermissionGroup.storage] != PermissionStatus.granted){
        return null;
      }
    }
    return true;
  }


  void disposeService(){
    WallpaperUrl?.close();
    Popular?.close();
    Search?.close();
    WallpaperUrl?.close();
    Wallpaperhd?.close();
    _interstitialAd?.dispose();
  }

}





