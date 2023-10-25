import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import 'package:post/Screens/Leave1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/leaveDeatils.dart';
import '../utils/Custom_Appbar.dart';
import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';

class Leave extends StatefulWidget {
  @override
  LeavePage createState() => LeavePage();
}

class LeavePage extends State<Leave> {
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
      street = "",
      id = "-",
      leavetype = "",
      status = "",
      noofdays = "",
      name = "",
      requesteddate = "",
      dor = "";

  var details = new Map();
  List<User> userList = [];

  void userProfile() async {
    firstname = "-";
    lastname = "-";
    emp_id = "-";
    dob = "-";
    doj = "";
    manager = "-";
    department = "-";
    designation = "-";
    id = "-";
    name = "-";
    leavetype = "-";
    requesteddate = "";
    dor = "-";

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
              item.containsKey('leaveType') &&
              item.containsKey('createdAt')) {
            //final DateTime dob = DateTime.parse(item['createdAt']);
            //final String formattedDob = DateFormat('dd MMM yyyy').format(dob);
            final User user = User(
              id: item['id'],
              dor: DateTime.parse(item['createdAt']),
              leaveType: item['leaveType']['name'],
              name: item['user']['name'],
              days: item['noOfDays'],
              dof: DateTime.parse(item['fromDate']),
              dot: DateTime.parse(item['toDate']),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Leave",
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
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            width: double.infinity,
            // decoration: BoxDecoration(color: Colors.white),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Container(
                  //padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Employee details".tr,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
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
                              "Employee Id".tr,
                              style: TextStyle(
                                //fontSize: 14.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 215,
                        ),
                        Column(
                          children: [
                            Text(
                              "A1200".tr,
                              style: TextStyle(
                                //fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
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
                              "Employee Name".tr,
                              style: TextStyle(
                                //fontSize: 14.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 183,
                        ),
                        Column(
                          children: [
                            Text(
                              "Balaji D".tr,
                              style: TextStyle(
                                //fontSize: 14.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
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
                              "Employee Id".tr,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 214,
                        ),
                        Column(
                          children: [
                            Text(
                              "Admin".tr,
                              style: TextStyle(
                                // fontSize: 14.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Text(
                  "Leave Manager".tr,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.blue),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
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
                              "Emp.ID".tr,
                              style: TextStyle(
                                  //fontSize: 20,
                                  fontFamily: 'Poppins',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
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
                                "June,2023".tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Emp.ID".tr,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "Empname".tr,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              "Requested on".tr,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 13),
                            child: Text(
                              "Type".tr,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          for (final user in userList)
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 20, bottom: 30),
                                  child: Text(
                                    "${user.id}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _navigateToUserDetail(user),
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 50, bottom: 30),
                                    child: Text(
                                      "${user.name}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 40, bottom: 30),
                                  child: Text(
                                    "${DateFormat('dd MMM yyyy').format(user.dor)}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 30, bottom: 30),
                                  child: Text(
                                    "${user.leaveType}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
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
                            style: TextStyle(
                              //fontSize: 20,
                              //fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
                            style: TextStyle(
                              //fontSize: 20,
                              //fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
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
                            style: TextStyle(
                              //fontSize: 20,
                              //fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
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
                            style: TextStyle(
                              //fontSize: 20,
                              //fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
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
                            style: TextStyle(
                              //fontSize: 20,
                              //fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
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
                            style: TextStyle(
                              //fontSize: 20,
                              //fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "images/circle-right-icon.png",
                            color: Colors.blue,
                          )),
                    )
                  ],
                ),
              )
            ]),
          )
        ])));
  }

  void _navigateToUserDetail(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Leave1(user: user),
      ),
    );
  }
}
