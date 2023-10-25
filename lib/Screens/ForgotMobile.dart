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
import 'package:localization/localization.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:post/Screens/TabView.dart';
import 'package:post/model/loginModel.dart';
import 'package:post/utils/SharedPreference.dart';
import 'package:post/utlis/constant_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';
import '../utils/makeApi.dart';
import 'OTPMobile.dart';

class ForgotMobile extends StatefulWidget {
  @override
  ForgotMobileScreen createState() => ForgotMobileScreen();
}

class ForgotMobileScreen extends State<ForgotMobile> {
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

    super.initState();
    GetDialog();
    //  userInitB();

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
                          'Verify it’s you'.tr,
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
                          'A password reset link will be sent to your registered mobile number / Email'
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
                      margin: EdgeInsets.only(left: 20, right: 20, top: 34),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onChanged: (val) {
                          setState(() {});
                        },
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          // errorText: validEmail,
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(color: yellow, width: 0.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'Mobile Number / Email'.tr,
                          hintStyle: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: grey_color,
                              fontFamily: 'Poppins'),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                        ),
                      ),
                    ),

                    // ignore: avoid_unnecessary_containers

                    Container(
                        height: 50,
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: ElevatedButton(
                            child: Text(
                              'Send OTP'.tr,
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

                              if (nameController.text.isEmpty) {
                                showInSnackBar(
                                    "* Please enter the Email / Mobile Number");
                              } else {
                                if (await hasNetwork()) {
                                  Get.to(OTPMobile());

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
                        'Back to '.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        //signup screen
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        'Log in'.tr,
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
}
