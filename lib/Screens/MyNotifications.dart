import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:post/utils/SharedPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/notificationList.dart';
import '../utils/Custom_Appbar.dart';
import '../utils/constantsApi.dart';
import '../utils/constants_colors.dart';
import '../utils/makeApi.dart';
import 'package:dio/dio.dart' as dio1;
import 'package:timeago/timeago.dart' as timeago;

class MyNotifications extends StatefulWidget {
  @override
  MyNotificationsPage createState() => MyNotificationsPage();
}

class MyNotificationsPage extends State<MyNotifications> {
  int? _selectedIndex = 0;
  final formkey = GlobalKey();
  notificationList? respModal;
  bool isLoading = true;
  List<dynamic> listMain = [];
  String locale = 'en';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocale();
  }

  Future<void> getLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    locale = prefs.getString('locale') ?? '';

    print('Locale:$locale');
    userInit();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: grey_trans,
      appBar: Custom_AppBar(
        key: formkey,
        title: "My Notifications".tr,
      ),
      // floatingActionButton: Container(
      //   child: CreatBtn(),
      // ),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : GroupedListView<dynamic, String>(
              elements: respModal!.list!,
              groupBy: (element) => element.date!,
              groupComparator: (value1, value2) => value2.compareTo(value1),
              // itemComparator: (item1, item2) =>
              //     item1['name'].compareTo(item2['name']),
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              groupSeparatorBuilder: (String value) => Container(
                color: grey_trans,
                padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                // margin: EdgeInsets.only(left: 10),
                child: Text(
                  calculateDifference(value),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: Colors.black,
                  ),
                ),
              ),
              itemBuilder: (c, element) {
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: new BorderSide(color: Colors.white, width: 0.5),
                    ),
                    color: Colors.white,
                    child: listData(element),
                  ),
                );
              },
            ),
    );
  }

  Widget listData(dynamic index) {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 5),
                child: Text(
                  index.title,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0, bottom: 5),
                alignment: Alignment.topRight,
                child: Text(
                  calculateDifference(index.date),
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 8.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: grey_color,
                  ),
                ),
              ),
            ],
          ),

          // SizedBox(height: 6),
          // Flexible(
          //   child:
          // ),

          Text(
            index.message,
            maxLines: 2,
            style: TextStyle(
              fontSize: 10.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
              color: grey_color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> userInit() async {
    dio1.FormData formData =
        dio1.FormData.fromMap({'user_id': await getUserId(), 'locale': locale});

    dynamic template = await MakeAPI()
        .postDataFuture(ConstantsAPi.notification_list, formData);
    respModal = notificationList();

    if (template != null) {
      setState(() {
        respModal = notificationList.fromJson(template.data);
        // print(respModal!.list![0].transactionId);
        // listMain = respModal!.list!;

        if (respModal!.status == "1") {
          isLoading = false;
        } else {
          showInSnackBar("No Data Found".tr);
        }
      });
    }
  }

  String calculateDifference(String date) {
    DateTime dateVal = DateFormat("dd MMM yyyy h:mm a").parse(date);

    DateTime now = DateTime.now();
    String time = "";

    int diff = DateTime(dateVal.year, dateVal.month, dateVal.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    if (diff == -1) {
      time = "Yesterday";
    } else if (diff == 0) {
      time = "Today";

      time = new DateFormat("hh:mm a").format(dateVal).toLowerCase();
    } else {
      time = timeago.format(dateVal, locale: 'en', allowFromNow: true);
    }

    return time;
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
