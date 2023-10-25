import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import 'package:post/Screens/AttendanceInfo.dart';
import 'package:post/model/AttendanceModel.dart';
//import 'package:post/model/paymentDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';

class Attendance extends StatefulWidget {
  @override
  AttendancePage createState() => AttendancePage();
}

class AttendancePage extends State<Attendance> {
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

  String? token = "";

  String? id = "-", date = "-", status = "-", out = "-", din = "-";

  var details = new Map();
  List<AttendanceDetails> userList = [];

  void userProfile() async {
    id = "-";
    status = "-";
    out = "-";
    din = "-";
    date = "-";

    // loadingGauge.showLoader(context);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token') ?? '';

    var url = ConstantsAPi.get_timeSheet;

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

      Map<String, dynamic> responseBody = response.data;

      print("MAP:${responseBody}");

      final Map<String, dynamic> items = responseBody['result']['data']['json'];
      print("token : ${userList}");
      if (items.containsKey('items')) {
        final List<dynamic> items1 = items['items'];

        for (final item in items1) {
          if (item is Map<String, dynamic> &&
              item.containsKey('id') &&
              item.containsKey('user') &&
              item.containsKey('inTime') &&
              item.containsKey('outTime')) {
            //final DateTime dob = DateTime.parse(item['createdAt']);
            //final String formattedDob = DateFormat('dd MMM yyyy').format(dob);
            final AttendanceDetails user = AttendanceDetails(
              id: item['id'],
              date: DateTime.parse(item['inTime']),
              out: DateTime.parse(item['inTime']),
              din: DateTime.parse(item['outTime']),
              status: item['status']['name'],
            );
            userList.add(user);
          }
        }

        setState(() {
          // details = userList[0];
          //print("token : ${details}");

          //firstname = details['firstName'];
          // lastname = details['lastName'];
          // emp_id = "${details['id']}";
          //id = "${details['id']}";
          userList = userList;

          // DateTime dobdate = DateTime.parse(details['dateOfBirth']);
          //DateTime dojdate = DateTime.parse(details['dateOfJoining']);
          // DateTime requested1 = DateTime.parse(details['createdAt']);

          //var formatter = DateFormat('dd MMM yyyy');
          // var dobformatted = formatter.format(dobdate);
          // var dojformatted = formatter.format(dojdate);
          //var reqDate = formatter.format(requested1);
          //print(dobformatted);

          // = "${dobformatted}";
          // doj = "${dojformatted}";
          //requesteddate = "${reqDate}";
          // department = details['department']['name'];
          // designation = details['designation']['name'];
          // manager = details['reportingManager']['name'];
        });

        loadingGauge.hideLoader();
      } else {
        print(response.statusMessage);
        loadingGauge.hideLoader();
      }
    }
  }

  // void userAddress() async {
  //   firstname = "-";
  //   lastname = "-";
  //   emp_id = "-";
  //   dob = "-";
  //   doj = "";
  //   manager = "-";
  //   department = "-";
  //   designation = "-";

  //   // loadingGauge.showLoader(context);

  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   token = prefs.getString('token') ?? '';

  //   var url = ConstantsAPi.get_address;

  //   var headers = {
  //     'Authorization': 'Bearer ${token}',
  //     'Content-Type': 'application/json',
  //     'Cookie': 'refreshToken=${token}'
  //   };
  //   var data = json.encode({
  //     "json": {"limit": 5, "page": 0}
  //   });
  //   var dio = Dio();
  //   var response = await dio.request('${url}',
  //       options: Options(
  //         method: 'POST',
  //         headers: headers,
  //       ),
  //       data: data);

  //   if (response.statusCode == 200) {
  //     // print(json.encode(response.data));

  //     Map responseBody = response.data;

  //     print("MAP Address:${responseBody}");

  //     //userList = responseBody['result']['data']['json']['items'];
  //     print("token : ${userList}");

  //     setState(() {
  //       details = userList[0];
  //       print("token : ${details}");

  //       city = details['city'];
  //       country = details['country'];
  //       pincode = "${details['pincode']}";
  //       state = "${details['state']}";
  //       street = "${details['street']}";

  //       addressType = details['addressType']['name'];
  //     });

  //     // List<dynamic> data = jsonDecode(response.data);
  //     //
  //     //
  //     //
  //     // // Access the values in the parsed JSON
  //     // for (var country in data) {
  //     //   print(country['result']);
  //     //
  //     // }

  //     // final Map parsed = json.decode(response.data);

  //     // print(parsed);

  //     loadingGauge.hideLoader();
  //   } else {
  //     print(response.statusMessage);
  //     loadingGauge.hideLoader();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Attendance",
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
          width: double.infinity,
          //height: double.infinity,
          decoration: BoxDecoration(color: Colors.white),

          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text("Attendance Manager",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue)),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        width: 160,
                        height: 40,
                        //padding: EdgeInsets.all(10),
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Emp.Id",
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.blue),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.blue),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 13,
                              ),
                              Container(
                                width: 100,
                                child: Text(
                                  "June,2023",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: IconButton(
                                    padding: EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.blue,
                                      size: 40,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 20),
                  child: Container(
                    //padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Employee details".tr,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),
                    ),
                  ),
                ),
                Container(
                  child: Row(children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Employee Id",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 215,
                          ),
                          Column(
                            children: [
                              Text(
                                "A1200",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
                Container(
                  child: Row(children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Employee Name",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 175,
                          ),
                          Column(
                            children: [
                              Text(
                                "Balaji D",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
                Container(
                  child: Row(children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Employee Id",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 207,
                          ),
                          Column(
                            children: [
                              Text(
                                "Admin",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("Emp.ID",
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("Date",
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 50),
                              child: Text("In",
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 50),
                              child: Text("Out",
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              child: Text("Status",
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            for (final user in userList)
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 45, bottom: 20),
                                    child: Text("${user.id}",
                                        style: GoogleFonts.poppins(
                                            // fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  GestureDetector(
                                    onTap: () => _navigateToUserDetail(user),
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 25, bottom: 20),
                                      child: Text(
                                          "${DateFormat('dd MMM yyyy').format(user.date)}",
                                          style: GoogleFonts.poppins(
                                              // fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 7, bottom: 20),
                                    child: Text(
                                        "${DateFormat('hh:mm a').format(user.date)}",
                                        style: GoogleFonts.poppins(
                                            // fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 13, bottom: 20),
                                    child: Text(
                                        "${DateFormat('hh:mm a').format(user.din)}",
                                        style: GoogleFonts.poppins(
                                            // fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 15, bottom: 20),
                                    child: Text("${user.status}",
                                        style: GoogleFonts.poppins(
                                            // fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                      //       Container(
                      //         margin: EdgeInsets.only(top: 30),
                      //         child: Row(
                      //           children: [
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1210",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 25),
                      //               child: Text("2023-06-23",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 7),
                      //               child: Text("9.00AM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 13),
                      //               child: Text("6.00PM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       Container(
                      //         margin: EdgeInsets.only(top: 30),
                      //         child: Row(
                      //           children: [
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1210",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 25),
                      //               child: Text("2023-06-23",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 7),
                      //               child: Text("9.00AM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 14),
                      //               child: Text(
                      //                 "6.00PM",
                      //                 style: TextStyle(
                      //                     //fontSize: 20,
                      //                     color: Colors.black,
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       Container(
                      //         margin: EdgeInsets.only(top: 30),
                      //         child: Row(
                      //           children: [
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1210",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 25),
                      //               child: Text("2023-06-23",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 7),
                      //               child: Text("9.00AM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 12),
                      //               child: Text("6.00PM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       Container(
                      //         margin: EdgeInsets.only(top: 30),
                      //         child: Row(
                      //           children: [
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1210",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 25),
                      //               child: Text("2023-06-23",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 7),
                      //               child: Text("9.00AM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 13),
                      //               child: Text("6.00PM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       Container(
                      //         margin: EdgeInsets.only(top: 30),
                      //         child: Row(
                      //           children: [
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1210",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 25),
                      //               child: Text("2023-06-23",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 7),
                      //               child: Text("9.00AM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 13),
                      //               child: Text("6.00PM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       Container(
                      //         margin: EdgeInsets.only(top: 30),
                      //         child: Row(
                      //           children: [
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1210",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 25),
                      //               child: Text("2023-06-23",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 7),
                      //               child: Text("9.00AM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 13),
                      //               child: Text("6.00PM",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.only(left: 45),
                      //               child: Text("1",
                      //                   style: GoogleFonts.poppins(
                      //                       // fontSize: 20,
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.w500)),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: IconButton(
                            onPressed: () {},
                            icon: Image.asset("images/arrowback.png")),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 70),
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blue),
                          child: Center(
                            child: Text(
                              "1",
                              style: GoogleFonts.poppins(
                                  // fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Container(
                          child: Center(
                            child: Text(
                              "2",
                              style: GoogleFonts.poppins(
                                  // fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Container(
                          child: Center(
                            child: Text(
                              "3",
                              style: GoogleFonts.poppins(
                                  // fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Container(
                          child: Center(
                            child: Text(
                              "4",
                              style: GoogleFonts.poppins(
                                  // fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Container(
                          child: Center(
                            child: Text(
                              "5",
                              style: GoogleFonts.poppins(
                                  // fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Container(
                          child: Center(
                            child: Text(
                              "6",
                              style: GoogleFonts.poppins(
                                  // fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 70),
                        child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              "images/circle-right-icon.png",
                              color: Colors.blue,
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Center(
                      child: FloatingActionButton(
                    onPressed: () {
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => Attendance2()));
                    },
                    child: Icon(Icons.add),
                  )),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ));
  }

  void _navigateToUserDetail(AttendanceDetails user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceInfo(user: user),
      ),
    );
  }
}
