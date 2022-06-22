
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
//import 'package:dio/dio.dart';
//import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:convert';
import '../utils/app_settings.dart';
import '../utils/app_strings.dart';
import '../model/model_news.dart';

class ScreenNews extends StatefulWidget {
  double height;
  String symbol;

  ScreenNews (this.height,this.symbol);

  @override
  State<StatefulWidget> createState() => _ScreenNews();
}

class _ScreenNews extends State<ScreenNews> {
  late Future<List<ModelNews>?> f;
  // late Response response;
  // Dio dio = Dio();
  //
  // bool    error = false; //for error status
  // bool  loading = false; //for data featching status
  // bool  refresh = false;
  // String errmsg = "";    //to assing any error message from API/runtime
  // var   apidata;         //for decoded JSON data


  List<ModelNews> parseNews (String responseBody) {
    print ('parseNews');
    //final parsed = jsonDecode ( responseBody ).cast<Map<String, dynamic>>();
    Map<String, dynamic> parsed = jsonDecode ( responseBody );
    print (parsed [ "Data" ].length);
    if ( parsed [ "Data" ] != null && parsed [ "Data" ].length > 0) {
      print ('calling');
      return parsed["Data"]
          .map<ModelNews>((json) => ModelNews.fromJSON(json))
          .toList();
    } else {
      return [];
    }
  }
  Future<List<ModelNews>?> fetchNewsInIsolate( urlNews ) async {
    //String urlNews = AppStrings().urlNews;
    if ( widget.symbol != "" ){
      urlNews += "&categories=${widget.symbol}"; //todo define param elsewhere
    }
    final response = await http.get( Uri.parse ( urlNews ) );
    //print (response.statusCode);
    if ( response.statusCode == 200 ) {
      // Use the compute function to run parsePhotos in a separate isolate.
      //return compute(parseNews, response.body);
      //print (response.body);
      return parseNews ( response.body );
    } else {
      return null;
    }
  }

  Future<List<ModelNews>?> fetchNews() async {
    List<ModelNews>? news = [];
    String urlNews = AppStrings().urlNews;
    if ( widget.symbol != "" ){
      urlNews += "&categories=${widget.symbol}"; //todo define param elsewhere
    }
    final response = await http.get( Uri.parse ( urlNews ) );
print (response.statusCode);
    if ( response.statusCode == 200 ) {
      // Server returns an OK response, parse the JSON
      Map<String, dynamic> responseJSON = json.decode( response.body );
      if ( responseJSON [ "Data" ] != null && responseJSON [ "Data" ].length > 0) {
        // if (kDebugMode) {
          print('Response data length ${responseJSON["Data"].length}');
          print ('Response data ${responseJSON["Data"].toString()}');
        // }
        for ( int i = 0; i < responseJSON["Data"].length; i++ ) {
          news.add( ModelNews.fromJSON ( responseJSON [ "Data" ][ i ] ) );
        }
        return news;
      }
    } else {
      // If server's answer is not OK
      return null;
    }
  }

  // Future<List<ModelNews>?> fetchCachedNews() async {
  //   List<ModelNews>? news = [];
  //   if ( !error ) {
  //     // Server returns an OK response, parse the JSON
  //     //Map<String, dynamic> responseJSON = json.decode( apidata );
  //     if ( apidata [ "Data" ] != null && apidata [ "Data" ].length > 0) {
  //       // if (kDebugMode) {
  //       //   print(responseJSON["Data"].length);
  //       //   print (responseJSON["Data"].toString());
  //       // }
  //       for ( int i = 0; i < apidata ["Data"].length; i++ ) {
  //         news.add( ModelNews.fromJSON ( apidata [ "Data" ][ i ] ) );
  //       }
  //       return news;
  //     }
  //   } else {
  //     // If server's answer is not OK
  //     return null;
  //   }
  // }

  // _getData () async {
  //   setState(() {
  //     loading = true;  //make loading true to show progressindicator
  //   });
  //   //don't use "http://localhost/" use local IP or actual live URL
  //   Response response = await dio.get( AppStrings().urlNews + '?lang=EN', options: buildCacheOptions(
  //     Duration ( days: 7 ), //duration of cache
  //     forceRefresh: refresh, //to force refresh
  //     maxStale: Duration ( days: 10 ), //before this time, if error like
  //     //500, 500 happens, it will return cache
  //   ));
  //   apidata = response.data; //get JSON decoded data from response
  //   print( apidata ); //printing the JSON recieved
  //   if ( response.statusCode == 200 ){
  //     //fetch successful
  //     if ( apidata [ "error" ] != null ){ //Check if there is error given on JSON
  //       error = true;
  //       errmsg  = apidata [ "msg" ]; //error message from JSON
  //     }
  //   } else {
  //     error = true;
  //     errmsg = "Error while fetching data.";
  //   }
  //
  //   loading = false;
  //   refresh = false;
  //   setState( () {} ); //refresh UI
  // }

  // @override
  // void initState() {
  //
  //   //dio.interceptors.add (DioCacheManager (CacheConfig (baseUrl: 'cryptocompare.com' ) ).interceptor);
  //   //_getData(); //fetching data
  //    super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ModelNews>?>(
      future: fetchNewsInIsolate ( AppStrings().urlNews), //TODO use fetchCachedNews
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: widget.height == 0.0 ? MediaQuery.of(context).size.height : widget.height,
            child: Card(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var datetime = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data![index].publishedOn * 1000);
                  var fmt = DateFormat( "dd/MM/yyyy" );
                  var dateString = fmt.format(datetime);
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only( top: 20.0, left: 20.0, right: 20.0 ),
                      child: Column(
                        children: <Widget>[
                          Text( snapshot.data![ index ].title,
                            style: AppSettings.newsListItemTitle,
                            textAlign: TextAlign.start,),
                          const SizedBox( height: 10.0, ),
                          Row( // News date, sourceInfo img and name
                            children: <Widget>[
                              Text( dateString,
                                style: AppSettings.newsListItemDate,),
                              Padding(
                                padding: const EdgeInsets.only( left: 10.0, right: 5.0 ),
                                child: Container( width: 20.0, height: 20.0,
                                  //child: Image.network( snapshot.data![ index ].sourceInfo.img ),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data![ index ].sourceInfo.img,
                                    imageBuilder: (context, imageProvider) => Container(
                                      //width: 400,
                                      //height: 200,
                                      decoration: BoxDecoration(
                                        image: DecorationImage( //image size fill
                                          image: imageProvider,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
                                    ), //show progress  while loading image
                                    errorWidget: (context, url, error) => Icon(Icons.error), //Image.asset("assets/noimage.jpg"),
                                    //show no image available image on error loading
                                  ),
                                ),
                              ),
                              Text( snapshot.data![ index ].sourceInfo.name,
                                style: AppSettings.newsListItemSourceInfoName,),
                            ],
                          ),
                          const Divider( height: 10.0, color: Colors.black87, ),
                        ],
                      ),
                    ),
                    onTap: () {// of GestureDetector
                      showBottomSheet( //better than "showModalBottomSheet"
                        context: context,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height - 100,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all ( 20.0 ),
                                      child: FittedBox (
                                        //child: Image.network( snapshot.data![ index ].imageURL ),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data![ index ].imageURL,
                                          imageBuilder: (context, imageProvider) => Container(
                                            width: 400,
                                            height: 200,
                                            decoration: BoxDecoration(
                                              image: DecorationImage( //image size fill
                                                image: imageProvider,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Container(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
                                          ), //show progress  while loading image
                                          errorWidget: (context, url, error) => Icon(Icons.error), //Image.asset("assets/noimage.jpg"),
                                          //show no image available image on error loading
                                        ),
                                        fit: BoxFit.fill,),),),
                                  Padding(
                                    padding: const EdgeInsets.only( left: 20.0, right: 20.0 ),
                                    child: Text( snapshot.data![ index ].title,
                                      style: AppSettings.newsInfoTitle,),),
                                  Padding(
                                    padding: const EdgeInsets.only( top: 10.0, left: 20.0, right: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text( dateString,
                                          style: AppSettings.newsInfoDate,),
                                        Padding(
                                          padding: const EdgeInsets.only( left: 10.0, right: 5.0),
                                          child: Container( width: 20.0, height: 20.0,
                                            child: Image.network( snapshot.data![ index ].sourceInfo.img ),),
                                        ),
                                        Text( snapshot.data![ index ].sourceInfo.name,
                                          style: AppSettings.newsCardSourceInfoName,),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left:20.0,right: 20.0,top: 5.0),
                                    child: Divider(color: Colors.black,height: 10.0,),),
                                  Padding(
                                    padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 10.0),
                                    child: Text( snapshot.data![index].body,
                                      style: AppSettings.newsCardBody,),),
                                  ListTile(
                                    trailing: TextButton (
                                      child: Text( AppStrings().textScreenNewsButtonOpenURL,
                                        style: AppSettings.newsButtonOpenURL,),
                                      onPressed: () async {
                                        if ( !await launchUrl ( Uri.parse ( snapshot.data![ index ].url ) ) ) {
                                          throw 'Could not launch ${snapshot.data![ index ].url}';
                                        }
                                      }, //onPressed
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        } else if(snapshot.hasError) {
          return Container(
            height: widget.height == 0.0 ? MediaQuery.of(context).size.height : widget.height,
            child: Center(
              child: Text( AppStrings().textScreenNewsNoAvailable ),
            ),
          );
        } else {
          return Container(
            height: widget.height == 0.0 ? MediaQuery.of(context).size.height : widget.height,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}