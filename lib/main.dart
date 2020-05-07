import 'package:bloc/bloc.dart';
import 'package:cotrak/CharitiesPage.dart';
import 'package:cotrak/CurvedShape.dart';
import 'package:cotrak/NavBar.dart';
import 'package:cotrak/NewsPage.dart';
import 'package:cotrak/StatsPage.dart';
import 'package:cotrak/blocs/simple_bloc_delegate.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:cotrak/blocs/news_bloc/news_bloc.dart';

const primaryColor = Color(0xff15406C);
const primaryColorLight1 = Color(0xff2F5A86);
const primaryColorLight2 = Color(0xff48739F);
const primaryColorLight3 = Color(0xff628DB9);
const primaryColorLight4 = Color(0xff7BA6D2);
const secondaryColor = Color(0xffE8F0FB);

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhia31ifWN9YGVoYmF8YGJ8ampqanNiYmlmamlmanMDHmg+fTs2NDIpKmpnEzs8Jz4yOj99MDw+");

  // final UserRepository userRepository = UserRepository();
  runApp(
    MyApp(/*userRepository: userRepository*/),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NewsBloc>(
            builder: (BuildContext context) => NewsBloc(),
          ),
        ],
        child: MyHomePage(),
      ),
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
