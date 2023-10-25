
import 'package:shared_preferences/shared_preferences.dart';



setUserId(String val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', val);
}
getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString('userId');
  return stringValue;
}

setCategoryId(String val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('catId', val);
}
getCategoryId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString('catId');
  return stringValue;
}

setTemplateId(String val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('tempCatId', val);
}
getTemplateId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString('tempCatId');
  return stringValue;
}

setTempImg(String val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('tempImg', val);
}
getTemplImg() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString('tempImg');
  return stringValue;
}
setEmail(String val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', val);
}
getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString('email');
  return stringValue;
}
setMobileNo(String val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('mobileNo', val);
}
getMobileNo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString('mobileNo');
  return stringValue;
}
// setMobileNo(String val) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString('mobileNo', val);
// }
// getMobileNo() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? stringValue = prefs.getString('mobileNo');
//   return stringValue;
// }







