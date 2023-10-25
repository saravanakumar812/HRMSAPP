import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio1;
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/SharedPreference.dart';
import '../utils/constantsApi.dart';
import '../utils/constants_colors.dart';
import '../utils/makeApi.dart';
import 'Home.dart';
import 'Login.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TabView extends StatefulWidget {
  // TabView({Key key}) : super(key: key);

  @override
  TabBarWidgetState createState() => TabBarWidgetState();
}

class TabBarWidgetState extends State<TabView> {
  String greeting = "";

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'தமிழ்', 'locale': Locale('ta', 'TA')},
  ];
  updateLanguage(Locale locale) {
    setState(() {});
    Get.back();
    Get.updateLocale(locale);
    getLocale();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Choose Your Language'),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () async {
                          print(locale[index]['name']);

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (locale[index]['name'] == 'ENGLISH') {
                            await prefs.setString('locale', 'en');
                          } else {
                            await prefs.setString('locale', 'en');
                          }

                          updateLanguage(locale[index]['locale']);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.blue,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  String titleName = "Home".tr;
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? userName = "", userEmail, mobileNo = "", userImg = "", token = "";
  String locales = 'en';

  static List<Widget> _widgetOptions = <Widget>[
    Home(),

    // HomeScreen(),
    // HomeScreen(),
    // MoreScreen(),
    // AddExtinguisher(isNewEnquiry: false),
    // MyEquipments(),
    // MyWallet(),
    // ProfileScreen(),
  ];

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime now = DateTime.now();

    int hours = now.hour;

    if (hours >= 1 && hours <= 12) {
      greeting = "Good Morning".tr;
    } else if (hours >= 12 && hours <= 16) {
      greeting = "Good Afternoon".tr;
    } else if (hours >= 16 && hours <= 21) {
      greeting = "Good Evening".tr;
    } else if (hours >= 21 && hours <= 24) {
      greeting = "Good Night".tr;
    }

    print("GREE AAA:${greeting}");

    setState(() {});

    getLocale();
  }

  Future<void> getLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    locales = prefs.getString('locale') ?? '';

    print('ABLocale:$locales');

    DateTime now = DateTime.now();

    int hours = now.hour;

    if (hours >= 1 && hours <= 12) {
      greeting = "Good Morning".tr;
    } else if (hours >= 12 && hours <= 16) {
      greeting = "Good Afternoon".tr;
    } else if (hours >= 16 && hours <= 21) {
      greeting = "Good Evening".tr;
    } else if (hours >= 21 && hours <= 24) {
      greeting = "Good Night".tr;
    }

    setState(() {});

    print("GREE BBB:${greeting}");

    setState(() {});

    userProfileDet();
  }

  Widget build(BuildContext context) {
    // TODO: implement build

    print('ABCLocale:$locales');

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          // shape: Border(bottom: BorderSide(color: secondaryTextColor)),
          elevation: 0.0,
          actions: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 0),
                child: Container(
                  width: 45,
                  height: 30,
                  child: Image.asset("images/world.png"),
                )),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: Image.asset("images/notification.png"),
                  color: Colors.white,
                  onPressed: () {
                    // Get.to(MyNotifications());
                  }),
            )
          ],
          title: selectedIndex == 0
              ? Row(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 0),
                      child: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _scaffoldKey.currentState!.openDrawer();
                          });
                        },
                      ),
                    ),
                  ],
                )
              : Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    selectedIndex == 1 ? "My Invitations".tr : "Packages".tr,
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                )),

      body: Center(
        child: selectedIndex == 6
            ? Container()
            : _widgetOptions.elementAt(selectedIndex),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 150,
              margin: EdgeInsets.only(top: 20),
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                        child: Container(
                      width: 50,
                      height: 50,
                      child: userImg!.isNotEmpty
                          ? Image.network(
                              userImg!,
                            )
                          : Image.asset("images/user_avatar.png"),
                    )),
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10, top: 5),
                            child: Text(
                              '$userName\n$mobileNo',
                              // 'PremKumar\n000 7777 7778',
                              maxLines: 3,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(0),
              height: 1,
              color: Colors.white,
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/menu_user.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Home'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_company.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Company Profile'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_attendance.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Attendance'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_leave.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Leave'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_mediacal.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Medical'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_loan.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Loan'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_payslip.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Pay Slip'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_suggestions.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'View All Suggestions'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_employee.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'View All Employee'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_documents.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Documents'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_learning.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Learning'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_gallary.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Gallary'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/ic_help.png",
                  color: Colors.black,
                ),
                onPressed: () {
                  // Get.to(MyProfile());
                  // Navigator.pop(context);
                },
              ),
              title: Text(
                'Help Desk'.tr,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Get.to(MyProfile());
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(20),
              height: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: IconButton(
                icon: Image.asset(
                  "images/log_out.png",
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              title: Text('Logout'.tr, style: TextStyle(color: Colors.black)),
              onTap: () {
                logoutDialog();
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(20),
              height: 0,
            ),
          ],
        ),
      ),
      // SafeArea(
      //   child: Container(
      //     width: MediaQuery.of(context).size.width *
      //         0.9, // 75% of screen will be occupied
      //     // margin: EdgeInsets.only(top: 40),
      //     // child: getDrawerMenu(),
      //   ),
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: onTabbarButtonTapped,
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: selectedIndex,
      //   backgroundColor: Colors.white,
      //   showSelectedLabels: true,
      //   showUnselectedLabels: true,
      //   selectedItemColor: yellow,
      //   unselectedItemColor: Colors.black,
      //   unselectedLabelStyle: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.w400,
      //       fontFamily: 'Poppins',
      //       fontSize: 10),
      //   selectedLabelStyle: TextStyle(
      //       color: yellow,
      //       fontWeight: FontWeight.w400,
      //       fontFamily: 'Poppins',
      //       fontSize: 10),
      //   // onTap: (int index) {
      //   //   setState(() {
      //   //     this.selectedIndex = index;
      //   //   });
      //   // },
      //   items: [
      //     BottomNavigationBarItem(
      //         label: 'Home'.tr,
      //         icon: Image.asset("lib/assets/images/home_black.png"),
      //         activeIcon: Image.asset('lib/assets/images/home.png')),
      //     BottomNavigationBarItem(
      //         label: 'My invitations'.tr,
      //         icon: Image.asset("lib/assets/images/invitation.png"),
      //         activeIcon:
      //         Image.asset('lib/assets/images/invitation_yellow.png')),
      //     BottomNavigationBarItem(
      //         label: 'Packages'.tr,
      //         icon: Image.asset('lib/assets/images/bucket.png'),
      //         activeIcon: Image.asset('lib/assets/images/bucket_yellow.png')),
      //     BottomNavigationBarItem(
      //         label: 'More'.tr,
      //         icon: Image.asset('lib/assets/images/more.png'),
      //         activeIcon: Image.asset('lib/assets/images/more_yellow.png')),
      //   ],
      // ),
    );
  }

  void onTabbarButtonTapped(int index) {
    setState(() {
      if (index != 3) {
        selectedIndex = index;
        // globals.selectedIdx = index;
      }
      switch (index) {
        case 0:
          {
            titleName = 'Home'.tr;
          }
          break;
        case 1:
          {
            titleName = 'MyInvitation'.tr;
          }
          break;
        case 2:
          {
            titleName = 'Packages'.tr;
          }
          break;
        case 3:
          {
            _scaffoldKey.currentState!.openDrawer();
          }
      }
    });
  }

  logoutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 140,
              child: Container(
                // padding: const EdgeInsets.all(12.0),
                margin: EdgeInsets.only(left: 15, right: 15, top: 5),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Text(
                        'Are you sure want to logout ?'.tr,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins'),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: yellow, minimumSize: Size(110, 40)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "No".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryColorLight,
                                minimumSize: Size(110, 40)),
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              userLogout();

                              final box = GetStorage();

                              box.write('email', '');
                              box.write('password', '');
                              Get.offAll(Login());
                            },
                            child: Text(
                              "Yes".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void userLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token') ?? '';

    var url = ConstantsAPi.logout;

    Map data = {
      // 'username': nameController.text,
      // 'password': passwordController.text,
    };
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        },
        body: body);
    print("${response.statusCode}");
    print("${response.body}");

    try {
      if (response.statusCode == 200) {
        String data = response.body;

        Map<String, dynamic> map = jsonDecode(data); // import 'dart:convert';

        print("${map}");
      } else {
        print("Failied");
      }
    } catch (e) {
      print("Failied Catch");
    }
  }

  Future<void> userProfileDet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('user_name') ?? '';
      mobileNo = prefs.getString('user_id') ?? '';
    });
  }
}
