//import 'dart:io';

class ConstantsAPi {
  static String apiPath = "https://clubits-hrms-demo.azurewebsites.net/trpc/";
  //static String apiPath = "https://anwarat.btwbs.xyz/Api/";
  static String imagePath =
      'https://alaipithal.unidemo.buzz/assets/upload/category/';
  static String forgotPassword = apiPath + 'forgot_otp';
  static String reset_password = apiPath + 'reset_password';
  static String login = apiPath + 'user.signIn';
  static String logout = apiPath + 'user.signOut';
  static String get_profile = apiPath + 'personalInfo.getMany';
  static String get_address = apiPath + 'address.getMany';
  static String get_leave = apiPath + 'leave.getMany';
  static String get_payment = apiPath + 'payRoll.getMany';
  static String get_timeSheet = apiPath + 'timeSheet.getMany';

  static String guard_login = apiPath + 'guard_login';

  static String register = apiPath + 'register';
  static String bucketList = apiPath + 'bucket_list';
  static String getProfile = apiPath + 'users/';
  static String verifyOtp = apiPath + 'verify_otp';
  static String singleInvite = apiPath + 'send_invitationSingle';
  static String choose_temp_cat = apiPath + 'category_list';
  static String theme_list = apiPath + 'template_list/';
  static String get_profile_details = apiPath + 'get_profile_details/';
  static String get_guard_details = apiPath + 'get_guard_details/';

  static String update_profile = apiPath + 'update_profile';
  static String transaction_list = apiPath + 'transaction_list';
  static String notification_list = apiPath + 'notification_list';
  static String myinvitation_list = apiPath + 'invitations_list';
  static String checkIn = apiPath + 'qr_validation';
  static String purchase = apiPath + 'purchase_invation_count';
  static String inv_status_list = apiPath + 'inv_status_list';
  static String get_enrolled_list = apiPath + 'get_enrolled_list';

  static String create_invitation = apiPath + 'create_invitation';
  static String edit_invitation = apiPath + 'edit_invitation';
  static String delete_invitation = apiPath + 'deleteinvitation';

  static String preview_invitation = apiPath + 'link';

  static String get_device_uniqueid = apiPath + 'get_device_uniqueid';
  static String send_invitation = apiPath + 'send_invitation';
  static String twilioAPI =
      "https://api.twilio.com/2010-04-01/Accounts/AC4a3f99546a10166610c1e9bfca75cce4/Messages.json";
  static String sentotp = "https://www.msegat.com/gw/sendsms.php";
}
