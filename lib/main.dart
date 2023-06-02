import 'dart:async';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:exchange/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:exchange/screen/intro/on_Boarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/constantClass.dart';

/// Run first apps open
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(myApp());
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'instant_notification',
        channelName: 'Basic Instant Notification',
        channelDescription: 'Notification channel that can trigger notification instantly.',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
      ),
      NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'scheduled_notification',
        channelName: 'Scheduled Notification',
        channelDescription:
            'Notification channel that can trigger notification based on predefined time.',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );
}

class myApp extends StatefulWidget {
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  // / Create _themeBloc for double theme (Dark and White theme)

  @override
  Widget build(BuildContext context) {
    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// StreamBuilder for themeBloc
    return MaterialApp(
      title: 'Tradebit',
      theme: day == false
          ? ThemeData.dark().copyWith(
              bottomSheetTheme:
                  BottomSheetThemeData(backgroundColor: Colors.transparent),
            )
          : ThemeData.light().copyWith(
              bottomSheetTheme:
                  BottomSheetThemeData(backgroundColor: Colors.transparent),
            ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen (),

      routes: <String, WidgetBuilder>{
        "onBoarding": (BuildContext context) => firstTime == "true"
            ?  onBoarding()
            : bottomNavBar(
                index: 0,
              ),
      },
    );
  }
}
/// Component UI

class SplashScreen extends StatefulWidget {
  SplashScreen();
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  _SplashScreenState();

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 5000), NavigatorPage);
  }

  /// To navigate layout change
  void  NavigatorPage() {
    firstTime == "true"
        ? Navigator.of(context).pushReplacementNamed("onBoarding")
        : Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>bottomNavBar(
              index: 0,
              ),

            ),
          );
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    getMode();
    startTime();
    currencyget();
    getCryptoData();
  }

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: day == false ?  Color(0xff070d10) : Colors.white,
      body: Container(
        child: Image.asset("assets/ilustration/splash.png",
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
