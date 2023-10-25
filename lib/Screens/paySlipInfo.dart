import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/paymentDetails.dart';
import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';

class PayslipInfo extends StatefulWidget {
  final Payslip user;

  PayslipInfo({required this.user});
  @override
  PayslipInfoPage createState() => PayslipInfoPage();
}

class PayslipInfoPage extends State<PayslipInfo> {
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
          "Attendence".tr,
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
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 30,
                  ),
                  child: Text(
                    "Name :".tr,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 78,
                ),
                Container(
                  child: Text(
                    "${widget.user.name}",
                    style: TextStyle(
                        fontFamily: "poppins",
                        // fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30, top: 20),
                  child: Text(
                    "Designation :".tr,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 38,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "${widget.user.designation}",
                    style: TextStyle(
                        // fontSize: 20,
                        fontFamily: "poppins",
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30, top: 20),
                  child: Text(
                    "Department :".tr,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 38,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "${widget.user.department}",
                    style: TextStyle(
                        // fontSize: 20,
                        fontFamily: "poppins",
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30, top: 20),
                  child: Text(
                    "Joining Month :".tr,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "${widget.user.month}",
                    style: TextStyle(
                        // fontSize: 20,
                        fontFamily: "poppins",
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30, top: 20),
                  child: Text(
                    "Joining Year :".tr,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 33,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "${widget.user.year}",
                    style: TextStyle(
                        // fontSize: 20,
                        fontFamily: "poppins",
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 20,
                  ),
                  child: Text(
                    "Earnings".tr,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    "Amount",
                    style: TextStyle(
                        // fontSize: 20,
                        fontFamily: "poppins",
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "${widget.user.basicName}",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    "Rs.${widget.user.basic}",
                    style: TextStyle(
                        // fontSize: 20,
                        fontFamily: "poppins",
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "${widget.user.hraName}",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    "Rs.${widget.user.hra}",
                    style: TextStyle(
                        // fontSize: 20,
                        fontFamily: "poppins",
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "Deductions".tr,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    "Amount",
                    style: TextStyle(
                        // fontSize: 20,
                        fontFamily: "poppins",
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "${widget.user.deductionName}",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    "Rs.${widget.user.deduction}",
                    style: TextStyle(
                        // fontSize: 20,
                        fontFamily: "poppins",
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
