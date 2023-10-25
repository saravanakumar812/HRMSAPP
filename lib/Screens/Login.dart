import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:country_codes/country_codes.dart';
import 'package:dio/dio.dart' as dio1;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:get/get.dart';
import 'package:post/Screens/TabView.dart';
import 'package:post/model/loginModel.dart';
import 'package:post/utils/SharedPreference.dart';
import 'package:post/utils/constants_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';
import '../utils/makeApi.dart';
import 'ForgotMobile.dart';
import 'Home.dart';
import 'package:localization/localization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:flutter/services.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:convert';

import 'LoginMobile.dart';

class Login extends StatefulWidget {
  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<Login> {
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
      validEmail = "* Please enter the email address";
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
    userInitB();

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
      String email = prefs.getString('username') ?? '';
      String password = prefs.getString('password') ?? '';

      nameController.text = email;
      passwordController.text = password;

      setState(() {
        _remVisible = true;
      });

      //  userInitDirect();
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
                  child: Image.asset("images/logo2.png"),
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
                          'Welcome Back!'.tr,
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
                          'Sign up to your account to access'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              fontFamily: 'Poppins'),
                        )),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 34),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: (val) {
                          setState(() {
                            validEmail = isValidEmail(val);
                          });
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
                          hintText: 'Email/Username'.tr,
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
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        obscureText: !_passwordVisible,
                        //This will obscure text dynamically
                        controller: passwordController,
                        style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,

                          // errorText: validatePwd,

                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(color: yellow, width: 0.0),
                          ),

                          border: OutlineInputBorder(),
                          // errorText: errorVal == "null" ? "" : errorVal,
                          hintText: 'Password'.tr,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),

                          hintStyle: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: grey_color,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            validatePwd = validatePassword(text);
                          });
                        },
                      ),
                    ),

                    // ignore: avoid_unnecessary_containers
                    Container(
                      margin: EdgeInsets.only(
                          top: 20, right: 10, left: 10, bottom: 0),
                      alignment: Alignment.bottomCenter,
                      // height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            // height: 150,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 30,
                                  child: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _remVisible
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: yellow,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _remVisible = !_remVisible;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  //alignment: Alignment.centerLeft,
                                  height: 40,
                                  child: TextButton(
                                      onPressed: () {
                                        //forgot password screen
                                        setState(() {
                                          _remVisible = !_remVisible;
                                        });
                                      },
                                      child: Text(
                                        'Remember me'.tr,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                            fontSize: 14),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 1),
                            child: TextButton(
                                onPressed: () {
                                  //forgot password screen
                                  Get.to(ForgotMobile());
                                },
                                child: Text(
                                  'Forgot Password ?'.tr,
                                  style: TextStyle(
                                      color: Colors.red,
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
                              'Login'.tr,
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

                              if (nameController.text == "") {
                                showInSnackBar("Enter Your Username/Email");
                              } else if (passwordController.text == "") {
                                showInSnackBar(validatePwd!);
                              } else {
                                if (await hasNetwork()) {
                                  //  Get.to(TabView());

                                  userInit();
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
                height: 50,
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
                        'Log in '.tr,
                        style: TextStyle(
                            color: yellow,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontSize: 20),
                      ),
                      onTap: () {
                        Get.to(LoginMobile());
                        //signup screen
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        'Using mobile number'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontSize: 18),
                      ),
                      onTap: () {
                        Get.to(LoginMobile());
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
    String? deviceId = await PlatformDeviceId.getDeviceId;

    loadingGauge.showLoader(context);
    var url = ConstantsAPi.login;

    Map data1 = {
      'username': nameController.text,
      'password': passwordController.text,
    };
    Map data = {
      'json': data1,
    };

    //encode Map to JSON
    // var body = json.encode(data);

    var body = json.encode({
      "json": {
        "username": nameController.text,
        "password": passwordController.text
      }
    });

    print("${body}");

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");

    try {
      if (response.statusCode == 200) {
        String data = response.body;

        Map<String, dynamic> map = jsonDecode(data); // import 'dart:convert';

        print("${map}");

        String token = map['result']['data']['json']['token'];
        print("token : ${token}");

        print("token : ${map['result']['data']['json']}");

        Map<String, dynamic> user_map = map['result']['data']['json']['user'];

        print("user_map : ${user_map}");

        String user_id = "${user_map['id']}";

        String user_name = "${user_map['name']}";
        String user_username = "${user_map['username']}";
        String email = "${user_map['email']}";
        String mobile = "${user_map['mobile']}";
        String role = "${user_map['role']['name']}";

        print("user_username : ${user_username}");
        print("role : ${role}");

        final box = GetStorage();
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        if (_remVisible) {
          box.write('device_unique', deviceId);
          box.write('username', nameController.text);
          box.write('password', passwordController.text);
          box.write('loggedin', "1");

          await prefs.setString('device_unique', deviceId!);
          await prefs.setString('username', nameController.text!);
          await prefs.setString('password', passwordController.text!);
          await prefs.setString('loggedin', '1');
        } else {
          box.write('loggedin', "");
          await prefs.setString('loggedin', '');
        }

        setUserName(user_name);
        setUserId(token);
        box.write('user_name', user_name);
        box.write('user_id', user_id);
        await prefs.setString('user_name', user_name);
        await prefs.setString('token', token);

        await prefs.setString('user_id', user_id);
        await prefs.setString('user_mobile', mobile);

        Get.to(TabView());
      } else {
        print("Failied");

        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Login Failed',
          desc: 'Invalid username or password',
          btnOkText: "Try Again",
          btnOkOnPress: () {},
        )..show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Network Failed',
        desc: 'Something went wrong',
        btnOkText: "Try Again",
        btnOkOnPress: () {},
      )..show();
    }

    loadingGauge.hideLoader();
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
