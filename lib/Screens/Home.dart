import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio1;
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:post/Screens/Leave.dart';
import 'package:post/Screens/Login.dart';
import 'package:post/Screens/attendance.dart';
import 'package:post/Screens/paySlip.dart';
import 'package:post/Screens/profile.dart';
import 'package:post/model/profileDetailes.dart';
import 'package:post/utils/SharedPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/bucketsModel.dart';
import '../model/invitationModel.dart';
import '../model/loginModel.dart';
import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';
import '../utils/constants_colors.dart';
import '../utils/makeApi.dart';

class Home extends StatefulWidget {
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> {
  String _scanBarcode = 'Unknown';
  final loadingGauge = LoadingGauge();

  bucketsModel? respModal;
  bool isLoading = true;
  profileDetails? respModalProfile;
  String purchasedLength = '0';
  int totalInvitationlength = 0;

  String locale = 'tr';
  String result = '';

  String user_name = '';
  String user_id = '';
  String user_mobile = '';

  Future<void> GetDialog() async {
    if (!await hasNetwork()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'No internet connection',
        desc: 'Please check your connection status and try again',
        btnOkText: "Try Again",
        btnOkOnPress: () {
          GetDialog();
        },
      )..show();
    }
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserProfileAPI();
    getLocale();
    //  userInit();
    GetDialog();
    // getDeviceAPI();

    final box = GetStorage();
    print(box.read('device_unique'));
  }

  Future<void> getLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user_id = prefs.getString('user_id') ?? '';
      user_name = prefs.getString('user_name') ?? '';
      user_mobile = prefs.getString('user_mobile') ?? '';
    });

    print('LocaleABSC:$user_name');
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Anwarat',
        text: 'Please download this beautiful app for sending invitations',
        linkUrl: 'https://anwarat.com/',
        chooserTitle: 'Download');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: appback,
      body: ListView(
        padding: const EdgeInsets.all(15.0),

        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              userBar(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              conProfile(),
              conAttendance(),
              conLeave(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              conMedical(),
              conLoan(),
              conPayslip(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              conSuggestion(),
              conAnony(),
              conGallary(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              conLearning(),
              condocuments(),
              SizedBox(
                height: 110,
                width: 100,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.question_mark_rounded),
      ),
    );
  }

  Widget userBar() {
    return GestureDetector(
        onTap: () {
          // Get.to(CreateInvitation());
          GetDialog();
          //Get.to(() => CreateInvitation());
        },
        child: Container(
          //height: 120,
          width: MediaQuery.of(context).size.width - 30,
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(10),
          //       topRight: Radius.circular(10),
          //       bottomLeft: Radius.circular(10),
          //       bottomRight: Radius.circular(10)),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 7,
          //       offset: Offset(0, 3), // changes position of shadow
          //     ),
          //   ],
          // ),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // height: 60,
                    // width: 60,
                    margin: EdgeInsets.only(
                      top: 30,
                      right: 0,
                    ),

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
                ],
              )
            ],
          ),
        )

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
        //height: 80,
        width: 150,
        margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        // child: Expanded(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: 20,
            // ),
            Text(
              "${user_name}".tr,
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${user_id}".tr,
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conProfile() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        Get.to(() => ProfileDetails());
      },
      child: Container(
        height: 110,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/profile_icon.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Profile".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conAttendance() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        Get.to(() => Attendance());
      },
      child: Container(
        height: 110,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/attendance.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Attendance".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conLeave() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        // Get.to(() => CreateInvitation());
        Get.to(() => Leave());
      },
      child: Container(
        height: 110,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/leave.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Leave".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conMedical() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        // Get.to(() => CreateInvitation());
      },
      child: Container(
        height: 110,
        width: 100,
        //  margin: EdgeInsets.only(left: 5,right: 5,  top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/mediacl.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Medical".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conLoan() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        // Get.to(() => CreateInvitation());
      },
      child: Container(
        height: 110,
        width: 100,
        // margin: EdgeInsets.only(left: 5,right: 5,  top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/loan.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Loan".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conPayslip() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        Get.to(() => PaySlip());
      },
      child: Container(
        height: 110,
        width: 100,
        //  margin: EdgeInsets.only(left: 5,right: 5,  top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/payslip.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Payslip".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conSuggestion() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        // Get.to(() => CreateInvitation());
      },
      child: Container(
        height: 110,
        width: 100,
        // margin: EdgeInsets.only(left: 5,right: 5,  top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/suggesntion.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Suggestion".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conAnony() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        // Get.to(() => CreateInvitation());
      },
      child: Container(
        height: 110,
        width: 100,
        // margin: EdgeInsets.only(left: 5,right: 5,  top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/anony.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Anonymous".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conGallary() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        // Get.to(() => CreateInvitation());
      },
      child: Container(
        height: 110,
        width: 100,
        // margin: EdgeInsets.only(left: 5,right: 5,  top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/gallary.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Gallary".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget conLearning() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        // Get.to(() => CreateInvitation());
      },
      child: Container(
        height: 110,
        width: 100,
        // margin: EdgeInsets.only(left: 20,right: 5,  top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/learning.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Learning".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget condocuments() {
    return GestureDetector(
      onTap: () {
        // Get.to(CreateInvitation());
        GetDialog();
        // Get.to(() => CreateInvitation());
      },
      child: Container(
        height: 110,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              // width: 60,
              margin: EdgeInsets.only(top: 32, bottom: 6),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: new ExactAssetImage('lib/assets/images/plus.png'),
              //     fit: BoxFit.fitWidth,
              //   ),
              //   shape: BoxShape.circle,
              // ),

              child: Image.asset(
                'images/documents.png',
                height: 40,
                width: 40,
                fit: BoxFit.fitHeight,
              ),
              // fit: BoxFit.fill,
              // )
            ),

            // FittedBox(
            //   child:Image.asset(
            //       'lib/assets/images/plus.png'),
            //   fit: BoxFit.fill,
            // ),

            Text(
              "Documents".tr,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  invitationModel? respModal1;

  Future<void> userInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? action = prefs.getString('device_unique');

    String intValue = prefs.getString('device_unique') ?? '';

    print('a');
    print(intValue);
    print('b');

    print('b${locale}');

    dio1.FormData formData = dio1.FormData.fromMap({
      'user_id': await getUserId(),
      'locale': locale,
    });

    print("PKPK${respModal1}");
    print("PKPK${respModal}");

    dynamic template = await MakeAPI().getAPICall(ConstantsAPi.bucketList);
    respModal = bucketsModel();
    //  respModal1 = invitationModel();

    if (template != null) {
      setState(() {
        respModal = bucketsModel.fromJson(template);

        isLoading = false;
      });
    }

    /*
    dynamic template1 = await MakeAPI()
        .postDataFuture(ConstantsAPi.myinvitation_list, formData);
    respModal1 = invitationModel();

    if (template1 != null) {
      setState(() async {
        respModal1 = invitationModel.fromJson(template1.data);
        totalInvitationlength = respModal1!.list!.length;
         print("pavithramanoharan ${template1.data!}");
        // print(respModal!.list![0].transactionId);
        // listMain = respModal!.list!;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? device_unique = prefs.getString('device_unique');
        print("Devuce ${device_unique}");
        if (respModal1!.status == "1") {
          isLoading = false;
        } else {
          isLoading = false;
          // showInSnackBar("No Data Found");
        }
      });
    } */
  }

  void getUserProfileAPI() async {
    //loadingGauge.showLoader(context);

    dio1.FormData formData = dio1.FormData.fromMap({
      'user_id': await getUserId(),
    });

    String urlstring = ConstantsAPi.get_profile_details;

    print(urlstring);
    print(qrValue);
    print(await getUserId());

    MakeAPI()
        .postData(urlstring, formData, loadingGauge, context)
        .then((responseJson) {
      Map<String, dynamic> JSON = responseJson.data;

      //String token = data["data"]["access_token"];
      String token = JSON["status"];

      print('JSON ${JSON}');

      print('TokenAS ${token}');

      if (token == "1") {
        print("PKPK");

        Map<String, dynamic> user_date = JSON["user_data"];

        print("PKPK");
        print(user_date);

        String no_of_invitation = user_date["no_of_invitation"];
        //String inv_count = JSON["inv_count"];
        purchasedLength = user_date["no_of_invitation"];
        setState(() {});
        print("PKPK");
        print(no_of_invitation);
        // print(inv_count);
        print("PKPK");

        int inv_count = JSON["inv_count"];
        //String inv_count = JSON["inv_count"];

        print("PKPK");
        print(inv_count);
        // print(inv_count);
        print("PKPK");

        totalInvitationlength = inv_count;

        setState(() {});

        // showInSnackBar('${JSON["message"]}');
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Try Again',
          desc: "Invalid or Expired",
          btnOkOnPress: () {},
        )..show();
      }

      loadingGauge.hideLoader();
    });
  }

  void getDeviceAPI() async {
    dio1.FormData formData = dio1.FormData.fromMap({
      'user_id': await getUserId(),
    });

    // Get.off(Home());

    print("pREMKUMAR");

    MakeAPI()
        .postData(
            ConstantsAPi.get_device_uniqueid, formData, loadingGauge, context)
        .then((responseJson) {
      loadingGauge.hideLoader();

      loginModel respModal = loginModel.fromJson(responseJson.data);
      print(respModal);
      if (respModal.status == "1") {
        setState(() async {
          String invid = responseJson.data["device_unique_id"];
          print(invid);

          final SharedPreferences prefs = await SharedPreferences.getInstance();

          final String? action = prefs.getString('device_unique');

          String intValue = prefs.getString('device_unique') ?? '';

          if (invid != intValue) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString('loggedin', '0');

            Get.to(Login());
          }
        });
      } else {
        // showInSnackBar("Oops! something went wrong");
      }
    });
  }

  String qrValue = "";

  void qrValidation() async {
    loadingGauge.showLoader(context);

    dio1.FormData formData = dio1.FormData.fromMap({
      'user_id': await getUserId(),
      'inv_id': qrValue,
    });

    String urlstring = ConstantsAPi.checkIn;

    print(urlstring);
    print(qrValue);
    print(await getUserId());

    MakeAPI()
        .postData(urlstring, formData, loadingGauge, context)
        .then((responseJson) {
      Map<String, dynamic> JSON = responseJson.data;

      //String token = data["data"]["access_token"];
      String token = JSON["status"];

      print('JSON ${JSON}');

      print('TokenAS ${token}');

      if (token == "1") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Scanned Successfully',
          desc: 'Invitation Checkedin Successfully',
          btnOkOnPress: () {},
        )..show();

        // showInSnackBar('${JSON["message"]}');
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Try Again',
          desc: "Invalid or Expired Invitation",
          btnOkOnPress: () {},
        )..show();
      }

      loadingGauge.hideLoader();
    });
  }

  void showInSnackBar(String value) {
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
}
