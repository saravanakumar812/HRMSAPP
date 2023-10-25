import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio1;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post/model/loginModel.dart';
import 'package:post/utils/SharedPreference.dart';
import 'package:post/utlis/constant_colors.dart';
import '../utils/Custom_Appbar.dart';
import '../utils/LoadingGauge.dart';
import '../utils/constantsApi.dart';
import '../utils/makeApi.dart';
import 'Home.dart';
import 'Login.dart';

class ChangePassword extends StatefulWidget {
  @override
  Change createState() => Change();
}

class Change extends State<ChangePassword> {
  TextEditingController confirmPwdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordControllerold = TextEditingController();
  final _text = '';
  bool _passwordVisible = false;
  bool _confirmpasswordVisible = false;

  String? validconfirmPwd = "", validatePwd = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final loadingGauge = LoadingGauge();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? validatePassword(String value) {
    if (value.isEmpty) {
      validatePwd = "* Please enter the password";
      return validatePwd;
    } else {
      validatePwd = "";
      return validatePwd;
    }
  }

  String? confirmvalidatePassword(String value, String value1) {
    if (value.isEmpty) {
      validconfirmPwd = "* Please enter the confirm password";
      return validconfirmPwd;
    } else if (!(value == value1)) {
      validconfirmPwd = "* Password mismatching";
      return validconfirmPwd;
    } else {
      validconfirmPwd = "";
      return validconfirmPwd;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // if(ConnectionStatusSingleton.getInstance().hasConnection){
    //
    // }else{
    //   GetDialog();
    // }

    _passwordVisible = false;
    _confirmpasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomInset: false,
      appBar: Custom_AppBar(
        key: formkey,
        title: "Change Password".tr,
      ),
      body: Container(
          constraints: const BoxConstraints.expand(),
          child: ListView(
            // mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 75),
                child: SizedBox(
                  height: 87,
                  child: Image.asset("lib/assets/images/logo.png"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 45),
                decoration: BoxDecoration(
                  color: white_transparent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: white_transparent), // boxShadow: [
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 45),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 16),
                        )),

                    Container(
                      height: 40,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        obscureText: !_passwordVisible,
                        //This will obscure text dynamically
                        controller: passwordControllerold,
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
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),

                          border: OutlineInputBorder(),
                          // errorText: errorVal == "null" ? "" : errorVal,
                          hintText: 'Old Password',
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
                    Container(
                      height: 40,
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
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),

                          border: OutlineInputBorder(),
                          // errorText: errorVal == "null" ? "" : errorVal,
                          hintText: 'New Password',
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

                    Container(
                      height: 40,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        obscureText: !_confirmpasswordVisible,
                        //This will obscure text dynamically
                        controller: confirmPwdController,
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
                              _confirmpasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _confirmpasswordVisible =
                                    !_confirmpasswordVisible;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),

                          border: OutlineInputBorder(),
                          // errorText: errorVal == "null" ? "" : errorVal,
                          hintText: 'Confirm Password',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),

                          hintStyle: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: grey_color,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    // ignore: avoid_unnecessary_containers
                    // Container(
                    //   alignment: Alignment.centerRight,
                    //   margin: const EdgeInsets.only(right: 10),
                    //   child: TextButton(
                    //       onPressed: () {
                    //         //forgot password screen
                    //         Get.to(ForgotPassword());
                    //       },
                    //       child: const Text(
                    //         'Forgot Password ?',
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.w400,
                    //             fontFamily: 'Poppins',
                    //             fontSize: 12),
                    //       )),
                    // ),

                    Container(
                        height: 40,
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(10, 32, 10, 60),
                        child: ElevatedButton(
                            child: const Text(
                              'CONTINUE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  fontSize: 14),
                            ),
                            onPressed: () {
                              if (!(validatePassword(
                                      passwordControllerold.text) ==
                                  "")) {
                                showInSnackBar(validatePwd!);
                              } else if (!(validatePassword(
                                      passwordController.text) ==
                                  "")) {
                                showInSnackBar(validatePwd!);
                              } else if (!(confirmvalidatePassword(
                                      confirmPwdController.text,
                                      passwordController.text) ==
                                  "")) {
                                showInSnackBar(validconfirmPwd!);
                              } else {
                                userInit();
                              }
                              // if (isValidEmail(nameController.text)) {
                              //   setState(() {
                              //     validEmail = "";
                              //   });

                              //   Get.to(TabView());
                              // } else {
                              //   setState(() {
                              //     validEmail =
                              //         "Please enter the valid email address";
                              //   });
                              // }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(yellow),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        side: const BorderSide(
                                            color: yellow)))))),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void GetDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'No internet connection',
      desc: 'Please check your connection status and try again',
      btnCancelOnPress: () {
        Navigator.pop(context);
      },
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();
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

  void userInit() async {
    loadingGauge.showLoader(context);

    dio1.FormData formData = dio1.FormData.fromMap({
      'user_id': await getUserId(),
      'user_password': passwordController.text,
      'confirmed_user_password': confirmPwdController.text,
    });

    MakeAPI()
        .postData(ConstantsAPi.reset_password, formData, loadingGauge, context)
        .then((responseJson) {
      loadingGauge.hideLoader();

      loginModel respModal = loginModel.fromJson(responseJson.data);

      if (respModal.status == "1") {
        showInSnackBar(respModal.message!);
        Get.off(Login());
      } else {}
    });
  }
}
