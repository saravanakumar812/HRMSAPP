import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';
import '../utils/constants_colors.dart';

class ProfileDetails extends StatefulWidget {
  @override
  ProfileDetailsPage createState() => ProfileDetailsPage();
}

class ProfileDetailsPage extends State<ProfileDetails> {
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
      this.userAddress();
    });
  }

  String? firstname = "-",
      lastname = "-",
      emp_id = "-",
      dob = "-",
      token = "",
      doj = "",
      manager = "-",
      department = "-",
      designation = "-";
  String? addressType = "-",
      city = "-",
      country = "-",
      pincode = "-",
      state = "",
      street = "";

  var details = new Map();
  List<dynamic> userList = [];

  void userProfile() async {
    firstname = "-";
    lastname = "-";
    emp_id = "-";
    dob = "-";
    doj = "";
    manager = "-";
    department = "-";
    designation = "-";

    // loadingGauge.showLoader(context);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token') ?? '';

    var url = ConstantsAPi.get_profile;

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

      userList = responseBody['result']['data']['json']['items'];
      print("token : ${userList}");

      setState(() {
        details = userList[0];
        print("token : ${details}");

        firstname = details['firstName'];
        lastname = details['lastName'];
        emp_id = "${details['id']}";

        DateTime dobdate = DateTime.parse(details['dateOfBirth']);
        DateTime dojdate = DateTime.parse(details['dateOfJoining']);

        var formatter = DateFormat('dd MMM yyyy');
        var dobformatted = formatter.format(dobdate);
        var dojformatted = formatter.format(dojdate);
        print(dobformatted);

        dob = "${dobformatted}";
        doj = "${dojformatted}";
        department = details['department']['name'];
        designation = details['designation']['name'];
        manager = details['reportingManager']['name'];
      });

      // List<dynamic> data = jsonDecode(response.data);
      //
      //
      //
      // // Access the values in the parsed JSON
      // for (var country in data) {
      //   print(country['result']);
      //
      // }

      // final Map parsed = json.decode(response.data);

      // print(parsed);

      loadingGauge.hideLoader();
    } else {
      print(response.statusMessage);
      loadingGauge.hideLoader();
    }
  }

  void userAddress() async {
    firstname = "-";
    lastname = "-";
    emp_id = "-";
    dob = "-";
    doj = "";
    manager = "-";
    department = "-";
    designation = "-";

    // loadingGauge.showLoader(context);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token') ?? '';

    var url = ConstantsAPi.get_address;

    var headers = {
      'Authorization': 'Bearer ${token}',
      'Content-Type': 'application/json',
      'Cookie': 'refreshToken=${token}'
    };
    var data = json.encode({
      "json": {"limit": 5, "page": 0}
    });
    var dio = Dio();
    var response = await dio.request('${url}',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data);

    if (response.statusCode == 200) {
      // print(json.encode(response.data));

      Map responseBody = response.data;

      print("MAP Address:${responseBody}");

      userList = responseBody['result']['data']['json']['items'];
      print("token : ${userList}");

      setState(() {
        details = userList[0];
        print("token : ${details}");

        city = details['city'];
        country = details['country'];
        pincode = "${details['pincode']}";
        state = "${details['state']}";
        street = "${details['street']}";

        addressType = details['addressType']['name'];
      });

      // List<dynamic> data = jsonDecode(response.data);
      //
      //
      //
      // // Access the values in the parsed JSON
      // for (var country in data) {
      //   print(country['result']);
      //
      // }

      // final Map parsed = json.decode(response.data);

      // print(parsed);

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Profile info",
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
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
          // decoration: BoxDecoration(
          //   color: white_transparent_80,
          //   shape: BoxShape.rectangle,
          //   borderRadius: BorderRadius.circular(10),
          //   border: Border.all(color: white_transparent), // boxShadow: [
          // ),
          child: ListView(
            children: [
              conTopEdit(),
              Container(
                // height: 60,
                // width: 60,
                margin: EdgeInsets.only(top: 0, right: 0, left: 30, bottom: 0),

                child: Image.asset(
                  'images/user_avatar.png',
                  height: 70,
                  width: 70,
                  fit: BoxFit.fitHeight,
                ),
                // fit: BoxFit.fill,
                // )
              ),
              conTopProfile(),
              Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: white_transparent_80,
                        blurRadius: 2,
                      ),
                    ],

                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    border:
                        Border.all(color: white_transparent), // boxShadow: [
                  ),
                  child: Text(
                    "Personal Details".tr,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  )),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Emp. ID".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: Text(
                          "${emp_id}",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DOB".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${dob}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DOJ".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${doj}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Department".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${department}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Designation".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${designation}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reporting Manager".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${manager}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.all(16),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Bio metric".tr,
              //         style: TextStyle(
              //           fontSize: 12.0,
              //           fontFamily: 'Poppins',
              //           fontWeight: FontWeight.w400,
              //           color: grey_color,
              //         ),
              //       ),
              //       Text(
              //         "007",
              //         style: TextStyle(
              //           fontSize: 12.0,
              //           fontFamily: 'Poppins',
              //           fontWeight: FontWeight.w600,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.all(16),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Mobile Number".tr,
              //         style: TextStyle(
              //           fontSize: 12.0,
              //           fontFamily: 'Poppins',
              //           fontWeight: FontWeight.w400,
              //           color: grey_color,
              //         ),
              //       ),
              //       Text(
              //         "888 999 8888",
              //         style: TextStyle(
              //           fontSize: 12.0,
              //           fontFamily: 'Poppins',
              //           fontWeight: FontWeight.w600,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: white_transparent_80,
                        blurRadius: 2,
                      ),
                    ],

                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    border:
                        Border.all(color: white_transparent), // boxShadow: [
                  ),
                  child: Text(
                    "Address".tr,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  )),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Type".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: Text(
                          "${addressType}",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Street".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${street}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "City".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${city}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Country".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${country}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Zip".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${pincode}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "State".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "${state}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: white_transparent_80,
                        blurRadius: 2,
                      ),
                    ],

                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    border:
                        Border.all(color: white_transparent), // boxShadow: [
                  ),
                  child: Text(
                    "Payment Details".tr,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  )),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Type".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: Text(
                          "-",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bank Name".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "-",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account No".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "-",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account Holder Name".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "-",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: white_transparent_80,
                        blurRadius: 2,
                      ),
                    ],

                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    border:
                        Border.all(color: white_transparent), // boxShadow: [
                  ),
                  child: Text(
                    "Qualification".tr,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  )),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Degree/Diplomo".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: Text(
                          "B.Tech",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Institution Name".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "Karunya",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Passing Year".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "1999",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Percentage".tr,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: grey_color,
                      ),
                    ),
                    Text(
                      "90%",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget conTopEdit() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        Get.to(() => ProfileDetails());
      },
      child: Container(
        height: 80,
        width: 200,
        margin: EdgeInsets.only(top: 0, right: 0, left: 30, bottom: 0),
        // child: Expanded(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 0, right: 0, left: 30, bottom: 0),

              child: Image.asset(
                'images/editprofile.png',
                height: 70,
                width: 100,
                fit: BoxFit.fitWidth,
              ),
              // fit: BoxFit.fill,
              // )
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conTopProfile() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        Get.to(() => ProfileDetails());
      },
      child: Container(
        height: 80,
        width: 200,
        margin: EdgeInsets.only(top: 0, right: 0, left: 30, bottom: 0),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              "${firstname} ${lastname}".tr,
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset(
                    "images/linkedin.png",
                    color: Colors.blue,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Image.asset(
                    "images/mail.png",
                    color: Colors.blue,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
