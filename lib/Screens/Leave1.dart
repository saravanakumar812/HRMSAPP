import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/leaveDeatils.dart';
import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';

class Leave1 extends StatefulWidget {
  final User user;

  Leave1({required this.user});
  @override
  Leave1Page createState() => Leave1Page();
}

class Leave1Page extends State<Leave1> {
  final formkey = new GlobalKey();
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  // var textController = TextEditingController();
  final loadingGauge = LoadingGauge();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(11.0168, 76.9558),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserProfileAPI();

    Future.delayed(Duration.zero, () {
      this.userProfile();
      //this.userAddress();
    });
  }

  String? dob = "-",
      doj = "",
      name = "-",
      id = "-",
      requestedOn = "-",
      fromDate = "-",
      toDate = "-",
      leaveType = "-",
      days = "-",
      status = "-",
      appOn = "",
      token = '';

  String? addressType = "-",
      city = "-",
      country = "-",
      pincode = "-",
      state = "",
      street = "";

  var details = new Map();
  List<Map<String, dynamic>> userList = [];

  void userProfile() async {
    name = "-";
    id = "-";
    requestedOn = "-";
    fromDate = "-";
    toDate = "-";
    leaveType = "-";
    days = "-";
    status = "-";
    appOn = "";
    token = "";
    dob = "-";
    doj = "";

    // loadingGauge.showLoader(context);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    var url = ConstantsAPi.get_leave;

    var headers = {
      'Authorization': 'Bearer ${token}',
      'Content-Type': 'application/json',
      'Cookie': 'refreshToken=${token}'
    };
    var data = json.encode({
      "json": {"limit": 5, "page": 0}
    });
    var dio = Dio();
    var response = await dio.request(
      '${url}',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));

      Map responseBody = response.data;

      print("MAP:${responseBody}");

      final Map<String, dynamic> items = responseBody['result']['data']['json'];
      print("token : ${userList}");
      if (items.containsKey('items')) {
        final List<dynamic> items1 = items['items'];

        for (final item in items1) {
          if (item is Map<String, dynamic> &&
              item.containsKey('id') &&
              item.containsKey('user') &&
              item.containsKey('leaveType') &&
              item.containsKey('createdAt')) {
            final DateTime dob = DateTime.parse(item['createdAt']);
            final String formattedDob = DateFormat('dd MMM yyyy').format(dob);
            final Map<String, dynamic> user = {
              'id': item['id'],
              'createdAt': formattedDob,
              'leaveType': item['leaveType']['name'],
              'user': item['user']['name']
            };
            userList.add(user);
          }
        }
      }

      setState(() {
        userList = userList;
        // details = userList[0];
        // print("token : ${details}");

        // id = "${details['id']}";
        // name = details['user']['name'];
        // leaveType = details['leaveType']['name'];
        // days = details['noOfDays'];
        // status = details['status']['name'];

        // DateTime dordate = DateTime.parse(details['createdAt']);
        // DateTime dofdate = DateTime.parse(details['fromDate']);
        // DateTime dotdate = DateTime.parse(details['toDate']);

        // var formatter = DateFormat('dd MMM yyyy');
        // var dorformatted = formatter.format(dordate);
        // var dofformatted = formatter.format(dofdate);
        // var dotformatted = formatter.format(dotdate);
        // print(dorformatted);

        // requestedOn = "${dorformatted}";
        // fromDate = "${dofformatted}";
        // toDate = "${dotformatted}";
      });

      loadingGauge.hideLoader();
    } else {
      print(response.statusMessage);
      loadingGauge.hideLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Leave Info".tr,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: 160,
                    ),
                    child: Text(
                      'Leave info',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: Color(0xff0771de),
                      ),
                    ),
                  ),
                  Container(
                    // frame7Rxm (1:1239)

                    width: 15.33,
                    height: 15.33,
                    child: Image.asset(
                      'images/frame-7-uQM.png',
                      width: 15.33,
                      height: 15.33,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                    // fontSize: 20,
                                    fontFamily: 'Poppins',
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 89,
                          ),
                          Column(
                            children: [
                              // for (final user in userList)
                              Text(
                                "${widget.user.name}",
                                style: TextStyle(
                                    // fontSize: 20,
                                    fontFamily: 'poppins',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Emp.ID",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 82,
                      ),
                      Column(
                        children: [
                          Text(
                            "${widget.user.id}",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Requested on",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 42,
                      ),
                      Column(
                        children: [
                          Text(
                            "${DateFormat('dd MMM yyyy').format(widget.user.dor)}",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "From",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 94,
                      ),
                      Column(
                        children: [
                          Text(
                            "${DateFormat('dd MMM yyyy').format(widget.user.dof)}",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "To",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 111,
                      ),
                      Column(
                        children: [
                          Text(
                            "${DateFormat('dd MMM yyyy').format(widget.user.dot)}",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Leave type",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Column(
                        children: [
                          Text(
                            "${widget.user.leaveType}",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Days",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 96,
                      ),
                      Column(
                        children: [
                          Text(
                            "${widget.user.days}",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 87,
                      ),
                      Column(
                        children: [
                          Text(
                            "${widget.user.status}",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Apporoved by",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 41,
                      ),
                      Column(
                        children: [
                          Text(
                            "Balaji Dayalan",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Emp.Code",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 63,
                      ),
                      Column(
                        children: [
                          Text(
                            "000 007",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Apporoved On",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 38,
                      ),
                      Column(
                        children: [
                          Text(
                            "${DateFormat('dd MMM yyyy').format(widget.user.dor)}",
                            style: TextStyle(
                                // fontSize: 20,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
