import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio1;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
//import 'Home.dart';
import 'package:localization/localization.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:post/Screens/TabView.dart';
import 'package:post/model/loginModel.dart';
import 'package:post/utils/SharedPreference.dart';
import 'package:post/utlis/constant_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';

import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';
import '../utils/makeApi.dart';
import 'ChangeMobile.dart';

class OTPMobile extends StatefulWidget {
  @override
  OTPMobileScreen createState() => OTPMobileScreen();
}

class OTPMobileScreen extends State<OTPMobile> {
  late DateTime alert;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _text = '';
  bool _passwordVisible = false;
  bool _remVisible = false;
  String? validEmail = "", validatePwd = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final loadingGauge = LoadingGauge();
  String? _platformVersion = 'Unknown';

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? validatePassword(String value) {
    if (value.isEmpty) {
      validatePwd = "* Please enter the password";
      return validatePwd;
    }
    // else if (value.length < 6) {
    //   validatePwd = "Password should be atleast 6 characters";
    //   return validatePwd;
    // }
    else {
      validatePwd = "";
      return validatePwd;
    }
  }

  String? isValidEmail(String email) {
    bool emailValid = RegExp(r'\S+@\S+\.\S+').hasMatch(email);

    if (email.isEmpty) {
      validEmail = "* Please enter the email address / Mobile Number";
    } else if (emailValid == false) {
      validEmail = "Please enter the valid email address";
    } else {
      validEmail = "";
    }

    return validEmail;
  }

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
    //Get.to(TabView());
    alert = DateTime.now().add(Duration(seconds: 60));

    super.initState();
    GetDialog();
    //userInitB();

    final box = GetStorage();
    print(box.read('loggedin'));
    print(box.read('email'));
    print(box.read('password'));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void userInitB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', 'ar');

    String intValue = prefs.getString('loggedin') ?? '';

    print('a');
    print(intValue);
    print('b');

    if (intValue == '1') {
      String email = prefs.getString('email') ?? '';
      String password = prefs.getString('password') ?? '';

      //  nameController.text = email;
      //  passwordController.text = password;
      userInitDirect();
    }

    // Get.to(() => EnterOTP(nameController.text));
  }

  void userInitDirect() async {
    Get.to(TabView());
  }

  int _currentSelection = 0;
  List<int> _disabledIndices = [];

  Map<int, Widget> _children = {
    0: Text('User'.tr),
    1: Text('Guard'.tr),
  };

  Future<void> GetLogin() async {
    Get.to(TabView());
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomInset: false,
      body: Container(
          constraints: const BoxConstraints.expand(),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 75),
                child: SizedBox(
                  height: 120,
                  child: Image.asset("images/images/logo2.png"),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 34),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Enter OTP'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 25),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        // margin: const EdgeInsets.on(10),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Enter 6 digit verification sent to your registered mobile number'
                              .tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              fontFamily: 'Poppins'),
                        )),
                    SizedBox(
                      height: 1,
                    ),

                    Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                      child: OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: 50,
                        style: TextStyle(fontSize: 15),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onCompleted: (pin) {
                          print("Completed: " + pin);
                        },
                      ),
                    ),

                    // ignore: avoid_unnecessary_containers

                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 0),
                      alignment: Alignment.bottomCenter,
                      // height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(right: 0),

                            child: TextButton(
                              onPressed: () {
                                //forgot password screen
                              },
                              child: TimerBuilder.scheduled([alert],
                                  builder: (context) {
                                // This function will be called once the alert time is reached
                                var now = DateTime.now();
                                var reached = now.compareTo(alert) >= 0;
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      !reached
                                          ? TimerBuilder.periodic(
                                              Duration(seconds: 1),
                                              alignment: Duration.zero,
                                              builder: (context) {
                                              // This function will be called every second until the alert time
                                              var now = DateTime.now();
                                              var remaining =
                                                  alert.difference(now);
                                              return Text(
                                                formatDuration(remaining),
                                              );
                                            })
                                          : Text("01:00"),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            // Text(
                            //   '0:60'.tr,
                            //   style: TextStyle(
                            //       color: Colors.black54,
                            //       fontWeight: FontWeight.w400,
                            //       fontFamily: 'Poppins',
                            //       fontSize: 14),
                            // )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: TextButton(
                                onPressed: () {
                                  //forgot password screen

                                  setState(() {
                                    alert = DateTime.now()
                                        .add(Duration(seconds: 60));
                                  });
                                },
                                child: Text(
                                  'Resend OTP'.tr,
                                  style: TextStyle(
                                      color: yellow,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      fontSize: 12),
                                )),
                          ),
                        ],
                      ),
                    ),

                    Container(
                        height: 50,
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: ElevatedButton(
                            child: Text(
                              'Confirm'.tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  fontSize: 14),
                            ),
                            onPressed: () async {
                              //  nameController.text = 'k1@gmail.com';
                              //  passwordController.text = '123456';

                              print(nameController.text);
                              print(passwordController.text);

                              if (await hasNetwork()) {
                                Get.to(ChangeMobile());

                                // if(_currentSelection == 0) {
                                //   userInit();
                                // }
                                // else
                                //   {
                                //       userInitGuard();
                                //   }
                              } else {
                                GetDialog();
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(yellow),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                            color: yellow)))))),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 26),
                alignment: Alignment.bottomCenter,
                // height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                        'Back'.tr,
                        style: TextStyle(
                            color: yellow,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontSize: 20),
                      ),
                      onTap: () {
                        Navigator.pop(context);

                        //signup screen
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
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

  void userInitA() async {
    Get.to(TabView());
  }

  void userInitGuard() async {
    _passwordVisible = false;
    _remVisible = false;

    loadingGauge.showLoader(context);

    String? deviceId = await PlatformDeviceId.getDeviceId;

    print(deviceId);

    dio1.FormData formData = dio1.FormData.fromMap({
      'guard_email': nameController.text,
      'guard_password': passwordController.text,
    });

    MakeAPI()
        .postData(ConstantsAPi.guard_login, formData, loadingGauge, context)
        .then((responseJson) async {
      loadingGauge.hideLoader();

      loginModel respModal = loginModel.fromJson(responseJson.data);

      if (respModal.status == "1") {
        print("ENTER");

        setUserId(respModal.userId!);

        final box = GetStorage();
        box.write('email', nameController.text);
        box.write('password', passwordController.text);
        box.write('loggedin_guard', "1");

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', nameController.text!);
        await prefs.setString('password', passwordController.text!);
        await prefs.setString('loggedin_guard', '1');

        // Get.to(ScanGuard());
      } else {
        showInSnackBar("Invalid Username or Password");
      }
    });
  }

  void userInit() async {
    _passwordVisible = false;

    loadingGauge.showLoader(context);

    String? deviceId = await PlatformDeviceId.getDeviceId;

    print(deviceId);

    dio1.FormData formData = dio1.FormData.fromMap({
      'user_email': nameController.text,
      'user_password': passwordController.text,
      'device_unique_id': deviceId,
    });

    MakeAPI()
        .postData(ConstantsAPi.login, formData, loadingGauge, context)
        .then((responseJson) async {
      loadingGauge.hideLoader();

      loginModel respModal = loginModel.fromJson(responseJson.data);

      if (respModal.status == "1") {
        setUserId(respModal.userId!);

        final box = GetStorage();
        box.write('device_unique', deviceId);
        box.write('email', nameController.text);
        box.write('password', passwordController.text);
        box.write('loggedin', "1");

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('device_unique', deviceId!);
        await prefs.setString('email', nameController.text!);
        await prefs.setString('password', passwordController.text!);
        await prefs.setString('loggedin', '1');

        setUserName(deviceId);

        Get.to(TabView());
      } else if (respModal.status == "2") {
        //setUserId(respModal.userId!);
        // Get.to(EnterOTP(nameController.text));

        sendOTP('${respModal.mobile!}', '${respModal.otp!}');

        // Get.to(() => EnterOTP(nameController.text));

        //showInSnackBar('This is for Testing Purpose OTP:${respModal.otp!}');
      } else {
        showInSnackBar("Invalid Username or Password");
      }
    });
  }

  void sendOTP(String mobileno, String otp) async {
    // loadingGauge.showLoader(context);
    var url = 'https://www.msegat.com/gw/sendsms.php';

    Map data = {
      'userName': 'Smpremium',
      'numbers': mobileno,
      'userSender': 'SM Premium',
      'apiKey': 'dfcd8bbbe76e2787c325dbf1655f5665',
      'msg': 'Verification Code : $otp'
    };
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    loadingGauge.hideLoader();
  }

  static Future<Future<bool>> setUserName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('device_unique', value);
  }

  String formatDuration(Duration d) {
    String f(int n) {
      return n.toString().padLeft(2, '0');
    }

    // We want to round up the remaining time to the nearest second
    d += Duration(microseconds: 999999);
    return "${f(d.inMinutes)}:${f(d.inSeconds % 60)}";
  }
}
