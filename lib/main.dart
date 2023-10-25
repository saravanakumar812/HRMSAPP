import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:post/Screens/Home.dart';
import 'package:post/Screens/Login.dart';
import 'package:post/model/LocaleString.dart';
import 'package:post/utils/ConnectionStatusSingleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51M5TjLE3CmPgciu7dtI15QsDHbvQAzidaKfYALZQ3F5dGg6rOvtUECFhira9q8eIFFkk70kTbHyPf0yWepmm92Pc00vaGogCkh';
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return GetMaterialApp(
      translations: LocaleString(),
      locale: const Locale('en', 'EN'),
      initialRoute: "/LoginScreen",
      debugShowCheckedModeBanner: false,
      initialBinding: HomeBinding(),
      getPages: [
        GetPage(
          name: '/home',
          page: () => Home(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/LoginScreen',
          page: () => Login(),
          binding: HomeBinding(),
        ),
      ],
      theme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),

        // Define the default font family.
        fontFamily: 'Poppins',
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.white, textTheme: ButtonTextTheme.primary),

        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.w500),
          // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}

class HomeBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.updateLocale(Locale.fromSubtags(languageCode: 'en'));
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('locale', 'en');

    Get.put(HomeController());
  }
}

class HomeController extends FullLifeCycleController with FullLifeCycleMixin {
  // Mandatory
  @override
  void onDetached() {
    print('HomeController - onDetached called');
  }

  // Mandatory
  @override
  void onInactive() {
    print('HomeController - onInative called');
  }

  // Mandatory
  @override
  void onPaused() {
    print('HomeController - onPaused called');
  }

  // Mandatory
  @override
  void onResumed() {
    print('HomeController - onResumed called');
  }
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
