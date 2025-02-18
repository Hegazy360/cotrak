import 'package:bloc/bloc.dart';
import 'package:cotrak/CharitiesPage.dart';
import 'package:cotrak/CurvedShape.dart';
import 'package:cotrak/AppLocalizations.dart';
import 'package:cotrak/NavBar.dart';
import 'package:cotrak/NewsPage.dart';
import 'package:cotrak/StatsPage.dart';
import 'package:cotrak/blocs/simple_bloc_delegate.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:cotrak/blocs/news_bloc/news_bloc.dart';
import 'package:firebase_admob/firebase_admob.dart';

const primaryColor = Color(0xff15406C);
const primaryColorLight1 = Color(0xff2F5A86);
const primaryColorLight2 = Color(0xff48739F);
const primaryColorLight3 = Color(0xff628DB9);
const primaryColorLight4 = Color(0xff7BA6D2);
const secondaryColor = Color(0xffE8F0FB);

// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
const String testDevice = '60447CDCFC9F5784BFDFD61E059F0BB7';

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhia31ifWN9YGVoYmF8YGJ8ampqanNiYmlmamlmanMDHmg+fTs2NDIpKmpnEzs8Jz4yOj99MDw+");

  runApp(
    MyApp(appLanguage: appLanguage,),
  );
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          locale: model.appLocal,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', ''),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],

          home: MultiBlocProvider(
            providers: [
              BlocProvider<NewsBloc>(
                builder: (BuildContext context) => NewsBloc(),
              ),
            ],
            child: MyHomePage(),
          ),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    StatsPage(),
    NewsPage(),
    CharitiesPage()
  ];

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
  );

  InterstitialAd _interstitialAd;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: "ca-app-pub-8400135927246890/8511977580",
      targetingInfo: targetingInfo,
    );
  }

  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-8400135927246890~1386783143");
    _interstitialAd = createInterstitialAd()
      ..load()
      ..show();

    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: secondaryColor,
      child: Stack(
        children: [
          CurvedShape(),
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            bottom: 0,
            child: NavBar(
              selectedIndex: _selectedIndex,
              onTabChange: _onTabChange,
            ),
          ),
        ],
      ),
    );
  }

  void _onTabChange(index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
