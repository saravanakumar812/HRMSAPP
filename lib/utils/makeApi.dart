import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import '../model/responseModel.dart';
import 'LoadingGauge.dart';
import 'exceptions.dart';

class MakeAPI {
  Future<dynamic> getAPICall(String url) async {
    var responseJson;

    try {
      Uri postURL = Uri.parse(url);

      final response = await http.get(
        postURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      responseJson = createResp(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson; // responseJson;
  }

  Future<Response> postData(String url, var body, LoadingGauge loadingGauge,
      BuildContext context) async {
    var responseJson;
    print("asssddss $body");
    try {
      responseJson = await Dio().post(url,
          data: body,
          options: Options(headers: {'Accept': 'application/json'}));
      print("Pavithramanoharan $responseJson");
    } on DioError catch (e) {
      print("Pavithramanoharan $e");
      loadingGauge.hideLoader();
      showInSnackBar(e.response!.extra.toString(), context);
    }
    return responseJson;
  }

  Future<Response> getData(String url) async {
    var responseJson;

    try {
      responseJson = await Dio().get(
        url,
        // options: Options(headers: {'Accept': 'application/json'})
      );
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  Future<Response> postDataWithAuth(String url, var body,
      LoadingGauge loadingGauge, BuildContext context, String basicAuth) async {
    var responseJson;

    try {
      responseJson = await Dio().post(url,
          data: body,
          options:
              Options(headers: <String, String>{'authorization': basicAuth}));
      print("PKPK $responseJson");
    } on DioError catch (e) {
      print("PKPK $e");
      loadingGauge.hideLoader();
      showInSnackBar(e.response!.extra.toString(), context);
    }
    return responseJson;
  }

  Future<Response> postDataMain(String url, var body, LoadingGauge loadingGauge,
      BuildContext context) async {
    var responseJson;

    try {
      responseJson = await Dio().post(url,
          data: body,
          options: Options(headers: {'Accept': 'application/json'}));
    } on DioError catch (e) {
      loadingGauge.hideLoader();
      showInSnackBar(e.response!.extra.toString(), context);
    }
    return responseJson;
  }

  Future<Response> postDataFuture(String url, var body) async {
    var responseJson;

    try {
      responseJson = await Dio().post(url,
          data: body,
          options: Options(headers: {'Accept': 'application/json'}));
    } on DioError catch (e) {
      // loadingGauge.hideLoader();
      // showInSnackBar(e.response!.extra.toString(), context);
    }
    return responseJson;
  }

  void showInSnackBar(String value, BuildContext context) {
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        value,
        style: TextStyle(color: Colors.white),
      ),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //

  dynamic createResp(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        // //print("ehhhhhhhho:"+ responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

// Future<String> uploadImage(filepath, url) async {
//   var request = http.MultipartRequest('POST', Uri.parse(url));
//   request.files.add(
//       http.MultipartFile.fromBytes(
//           'file',
//           filepath,
//           // filename: filepath.split("/").last
//       ),
//   );
//   var res = await request.send();
//
//   return res.toString();
// }
}
