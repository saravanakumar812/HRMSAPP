import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import 'package:post/model/AttendanceModel.dart';

import '../utils/LoadingGauge.dart';

class AttendanceInfo extends StatefulWidget {
  final AttendanceDetails user;

  AttendanceInfo({required this.user});
  @override
  AttendanceInfoPage createState() => AttendanceInfoPage();
}

class AttendanceInfoPage extends State<AttendanceInfo> {
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
      //this.userProfile();
      //this.userAddress();
    });
  }

  // String? dob = "-",
  //     doj = "",
  //     name = "-",
  //     id = "-",
  //     requestedOn = "-",
  //     fromDate = "-",
  //     toDate = "-",
  //     leaveType = "-",
  //     days = "-",
  //     status = "-",
  //     appOn = "",
  //     token = '';

  // String? addressType = "-",
  //     city = "-",
  //     country = "-",
  //     pincode = "-",
  //     state = "",
  //     street = "";

  // var details = new Map();
  // List<Map<String, dynamic>> userList = [];

  // void userProfile() async {
  //   name = "-";
  //   id = "-";
  //   requestedOn = "-";
  //   fromDate = "-";
  //   toDate = "-";
  //   leaveType = "-";
  //   days = "-";
  //   status = "-";
  //   appOn = "";
  //   token = "";
  //   dob = "-";
  //   doj = "";

  //   // loadingGauge.showLoader(context);

  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('token') ?? '';

  //   var url = ConstantsAPi.get_leave;

  //   var headers = {
  //     'Authorization': 'Bearer ${token}',
  //     'Content-Type': 'application/json',
  //     'Cookie': 'refreshToken=${token}'
  //   };
  //   var data = json.encode({
  //     "json": {"limit": 5, "page": 0}
  //   });
  //   var dio = Dio();
  //   var response = await dio.request(
  //     '${url}',
  //     options: Options(
  //       method: 'POST',
  //       headers: headers,
  //     ),
  //     data: data,
  //   );

  //   if (response.statusCode == 200) {
  //     print(json.encode(response.data));

  //     Map responseBody = response.data;

  //     print("MAP:${responseBody}");

  //     final Map<String, dynamic> items = responseBody['result']['data']['json'];
  //     print("token : ${userList}");
  //     if (items.containsKey('items')) {
  //       final List<dynamic> items1 = items['items'];

  //       for (final item in items1) {
  //         if (item is Map<String, dynamic> &&
  //             item.containsKey('id') &&
  //             item.containsKey('user') &&
  //             item.containsKey('leaveType') &&
  //             item.containsKey('createdAt')) {
  //           final DateTime dob = DateTime.parse(item['createdAt']);
  //           final String formattedDob = DateFormat('dd MMM yyyy').format(dob);
  //           final Map<String, dynamic> user = {
  //             'id': item['id'],
  //             'createdAt': formattedDob,
  //             'leaveType': item['leaveType']['name'],
  //             'user': item['user']['name']
  //           };
  //           userList.add(user);
  //         }
  //       }
  //     }

  //     setState(() {
  //       userList = userList;
  //       // details = userList[0];
  //       // print("token : ${details}");

  //       // id = "${details['id']}";
  //       // name = details['user']['name'];
  //       // leaveType = details['leaveType']['name'];
  //       // days = details['noOfDays'];
  //       // status = details['status']['name'];

  //       // DateTime dordate = DateTime.parse(details['createdAt']);
  //       // DateTime dofdate = DateTime.parse(details['fromDate']);
  //       // DateTime dotdate = DateTime.parse(details['toDate']);

  //       // var formatter = DateFormat('dd MMM yyyy');
  //       // var dorformatted = formatter.format(dordate);
  //       // var dofformatted = formatter.format(dofdate);
  //       // var dotformatted = formatter.format(dotdate);
  //       // print(dorformatted);

  //       // requestedOn = "${dorformatted}";
  //       // fromDate = "${dofformatted}";
  //       // toDate = "${dotformatted}";
  //     });

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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              width: 360,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'images/rectangle-28-bg.png',
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 160),
                decoration: BoxDecoration(
                  color: Color(0xe5deeeff),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      //  margin: EdgeInsets.all(15),
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        "images/tabler-icon-map-pin-filled.png",
                        height: 20,
                        width: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        'Navalur,Chennai',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Color(0xff000000),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 130),
                    child: Text(
                      'CHECKED IN  ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Color(0xff0771de),
                      ),
                    ),
                  ),
                  Text(
                    // amCJm (1:545)
                    '${DateFormat('hh:mm a').format(widget.user.out)}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: 120,
                    ),
                    child: Text(
                      'CHECKED OUT ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Color(0xff0771de),
                      ),
                    ),
                  ),
                  Text(
                    // amCJm (1:545)
                    '${DateFormat('hh:mm a').format(widget.user.din)}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: 60,
                    ),
                    child: Text(
                      'TOTAL HOURS WORKED ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Color(0xff0771de),
                      ),
                    ),
                  ),
                  Text(
                    // amCJm (1:545)
                    '8:00:00',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: 130,
                    ),
                    child: Text(
                      'BREAK HOURS',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Color(0xff0771de),
                      ),
                    ),
                  ),
                  Text(
                    // amCJm (1:545)
                    '1:00:00',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
