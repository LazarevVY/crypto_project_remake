import 'package:crypto_project_remake/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../model/model_crypto.dart';
//import 'secondscreen.dart'; //todo

class ScreenCoins extends StatefulWidget {
  const ScreenCoins({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreenCoins();
  }
}

class _ScreenCoins extends State<ScreenCoins> {
  late Response response;
  Dio dio = Dio( BaseOptions( headers: AppStrings().headersCoins ) );

  bool    error = false; //for error status
  bool  loading = false; //for data featching status
  bool  refresh = false;
  String errmsg = "";    //to assing any error message from API/runtime
  var   apidata;         //for decoded JSON data

  Future<List<ModelCrypto>?> fetchCrypto() async {
    List<ModelCrypto> cryptoDatas = [];

    final response = await http.get(
        Uri.parse(  AppStrings().urlCoins ),
        headers: AppStrings().headersCoins,
        );
    print ('Status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print ('Body: ${response.body}');
      // If server returns an OK response, parse the JSON
      Map<String, dynamic> responseJSON = json.decode(response.body);
      if (responseJSON["status"]["error_code"] == 0) {
        for (int i = 0; i < responseJSON["data"].length; i++) {
          cryptoDatas.add(ModelCrypto.fromJSON ( responseJSON[ "data" ][ i ] ) );
        }
        //print(cryptoDatas.length);
        return cryptoDatas;
      }
    } else {
      // If that response was not OK, throw an error.
      return null;
    }
  }
  Future<List<ModelCrypto>?> fetchCashedCrypto() async {
    List<ModelCrypto> cryptoDatas = [];

    if (!error) {
      //print ('Body: ${response.body}');
      // If server returns an OK response, parse the JSON
      //Map<String, dynamic> responseJSON = json.decode(response.body);
      if (apidata ["status"]["error_code"] == 0) {
        for (int i = 0; i < apidata ["data"].length; i++) {
          cryptoDatas.add(ModelCrypto.fromJSON ( apidata [ "data" ][ i ] ) );
        }
        //print(cryptoDatas.length);
        return cryptoDatas;
      }
    } else {
      // If that response was not OK, throw an error.
      return null;
    }
  }
  _getData () async {
    setState(() {
      loading = true;  //make loading true to show progressindicator
    });
    //don't use "http://localhost/" use local IP or actual live URL
    Response response = await dio.get( AppStrings().urlCoins, options: buildCacheOptions(
      Duration ( days: 7 ), //duration of cache

      forceRefresh: refresh, //to force refresh
      maxStale: Duration ( days: 10 ), //before this time, if error like
      //500, 500 happens, it will return cache
    ));
    apidata = response.data; //get JSON decoded data from response
    print( apidata ); //printing the JSON recieved
    if ( response.statusCode == 200 ){
      //fetch successful
      if ( apidata [ "error" ] != null ){ //Check if there is error given on JSON
        error = true;
        errmsg  = apidata [ "msg" ]; //error message from JSON
      }
    } else {
      error = true;
      errmsg = "Error while fetching data.";
    }

    loading = false;
    refresh = false;
    setState( () {} ); //refresh UI
  }

  @override
  void initState() {
    dio.interceptors.add (DioCacheManager (CacheConfig (baseUrl: AppStrings().urlCoins ) ).interceptor);
    _getData(); //fetching data
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<List<ModelCrypto>?>(
      future: fetchCashedCrypto(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var widthFinal = (MediaQuery.of(context).size.width - 30.0) / 5;
          return Column(

            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0.0),
                child: Container(

                  height: 20.0,
                  color: Colors.greenAccent,

                  child: Row(

                    children: <Widget>[
                      Container(
                          width: 30.0,
                          child: Text(
                            '#',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'RobotoLight',
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                      Container(
                          width: widthFinal,
                          child: Text(
                            'Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'RobotoLight',
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                      Container(
                          width: widthFinal + 30,
                          child: Text(
                            'Price(\$)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'RobotoLight',
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                      Container(
                          width: widthFinal - 10,
                          child: Text(
                            '1H',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'RobotoLight',
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                      Container(
                          width: widthFinal - 10,
                          child: Text(
                            '24H',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'RobotoLight',
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                      Container(
                          width: widthFinal - 10,
                          child: Text(
                            '7D',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'RobotoLight',
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    print ('snapshot.data.length: ${snapshot.data!.length}');
                    var colorHour=Colors.amber, colorDay=Colors.amber, color7d=Colors.amber;
                    if ((snapshot.data![ index ].quoteData.percentHour!.toDouble()) < 0 ) {
                      colorHour = Colors.red;
                    } else {
                      colorHour = Colors.green;
                    }
                    if ((snapshot.data![ index ].quoteData.percentDay!.toDouble()) < 0 ) {
                      colorDay = Colors.red;
                    } else {
                      colorDay = Colors.green;
                    }
                    if ((snapshot.data![ index ].quoteData.percentWeek!.toDouble()) < 0) {
                      color7d = Colors.red;
                    } else {
                      color7d = Colors.green;
                    }

                    return GestureDetector(
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Padding(

                                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6.0),
                                        child: Text( "${index+1}" ),),),
                                    Container(
                                      width: widthFinal,
                                      child: Column(
                                        children: <Widget>[
                                          FittedBox(
                                            child: Text(snapshot.data![ index ].name,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontFamily: 'RobotoLight',
                                                  color: Colors.black),
                                            ),
                                            fit: BoxFit.scaleDown,
                                          ),
                                          Text( snapshot.data![ index ].symbol,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: widthFinal + 30,
                                      child: FittedBox(
                                        child: Text(
                                          '\$ ${(snapshot.data![ index ].quoteData.price!.toDouble()).toStringAsFixed(2)}',
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontFamily: 'RobotoLight',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: FittedBox(
                                          child: Text(
                                            '${(snapshot.data![index].quoteData.percentHour!.toDouble()).toStringAsFixed(2)}%',
                                            style: TextStyle(
                                                color: colorHour,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                      width: widthFinal - 10,
                                    ),
                                    Container(
                                      width: widthFinal - 10,
                                      child: FittedBox(
                                        child: Text(
                                          '${(snapshot.data![ index ].quoteData.percentDay!.toDouble()).toStringAsFixed(2)}%',
                                          style: TextStyle(
                                              color: colorDay,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    Container(
                                      width: widthFinal - 10,
                                      child: FittedBox(
                                        child: Text(
                                          '${(snapshot.data![ index ].quoteData.percentWeek!.toDouble()).toStringAsFixed(2)}%',
                                          style: TextStyle(
                                              color: color7d,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Divider(
                            height: 2.0,
                            color: Colors.black54,
                          )
                        ],
                      ),
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder:
                        //     (context)=> SecondScreen(snapshot.data[index])
                        // ));
                      },
                    );
                  },
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('No Data');
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}