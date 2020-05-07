import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotrak/ChartsContainer.dart';
import 'package:cotrak/CotrakCountryPicker.dart';
import 'package:cotrak/CurvedShape.dart';
import 'package:cotrak/DailyData.dart';
import 'package:cotrak/HeaderText.dart';
import 'package:cotrak/HorizontalStatCards.dart';
import 'package:cotrak/RefreshIndicator.dart';
import 'package:country_code_picker/country_code_picker.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

const CURVE_HEIGHT = 300.0;
const primaryColor = Color(0xff15406C);
const primaryColorLight1 = Color(0xff2F5A86);
const primaryColorLight2 = Color(0xff48739F);
const primaryColorLight3 = Color(0xff628DB9);
const primaryColorLight4 = Color(0xff7BA6D2);
const secondaryColor = Color(0xffE8F0FB);

void main() {
  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhia31ifWN9YGVoYmF8YGJ8ampqanNiYmlmamlmanMDHmg+fTs2NDIpKmpnEzs8Jz4yOj99MDw+");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'CurvedShape',
      home: MyHomePage(title: 'CurvedShape'),
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
  var latestGlobalData = {};
  var latestCountryData = {};
  var dailyGlobalData = [];
  var dailyCountryData = {};
  var dailyData = {};

  var dataCards = ['confirmed', 'critical', 'deaths', 'recovered'];
  List countries = [];
  var dataCardsIcons = [
    LineIcons.check,
    LineIcons.heartbeat,
    Icons.short_text,
    LineIcons.heart_o
  ];
  var selectedCountry;
  String dataType = "total";
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController listViewController = new ScrollController();
  int _selectedIndex = 0;
  List<DailyData> dailyDataSource = [];
  List<DailyData> weeklyDataSource = [];
  List<DailyData> monthlyDataSource = [];

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Likes',
    ),
    Text(
      'Index 2: Search',
    ),
    Text(
      'Index 3: Profile',
    ),
  ];

  @override
  void initState() {
    getLatestGlobalData(resetListViewController: false);
    getAllCountries();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          SystemChrome.setEnabledSystemUIOverlays([]);
        }
      },
    );
    super.initState();
  }

  getAllCountries() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("countries")
        .getDocuments(source: Source.cache);

    if (querySnapshot == null) {
      querySnapshot = await Firestore.instance
          .collection("countries")
          .getDocuments(source: Source.server);
    }

    List<DocumentSnapshot> countriesSnapshots = querySnapshot.documents;

    querySnapshot.documents.map((countrySnapshot) {
      return countrySnapshot.data;
    });
    countriesSnapshots.forEach((countrySnapshot) {
      countries.add(countrySnapshot.data);
    });
  }

  getLatestGlobalData({resetListViewController: true}) async {
    final response = await http.get(
      'https://covid-19-data.p.rapidapi.com/totals?format=json',
      headers: {
        "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
        "x-rapidapi-key": "kobRJjesp4mshawkaj0YnlruOFmKp137FOGjsnwtgFFV9t5Lso"
      },
    );
    final responseJson = json.decode(response.body);

    setState(() {
      latestGlobalData = responseJson[0];
    });
    if (resetListViewController) {
      listViewController.animateTo(0.0,
          curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
    }
  }

  getLatestCountryData() async {
    final response = await http.get(
      'https://covid-19-data.p.rapidapi.com/country/code?code=$selectedCountry&format=json',
      headers: {
        "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
        "x-rapidapi-key": "kobRJjesp4mshawkaj0YnlruOFmKp137FOGjsnwtgFFV9t5Lso"
      },
    );
    final responseJson = json.decode(response.body);

    setState(() {
      latestCountryData = responseJson[0];
    });
    listViewController.animateTo(0.0,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
  }

  getDailyData() async {
    var country = countries
        .firstWhere((country) => selectedCountry == country['alpha2code']);

    var sameAsCurrentCountry = dailyData.length > 0 &&
        dailyData['daily'].values.first['country'] == country['name'];

    if (!sameAsCurrentCountry) {
      DocumentReference statsRef =
          Firestore.instance.collection("stats").document(country['name']);
      DocumentSnapshot getDoc = await statsRef.get();
      setState(() {
        dailyData = getDoc.data;
        updateDailyChartData();
      });

      listViewController.animateTo(0.0,
          curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
    }
  }

  updateDailyChartData() {
    if (dailyData['daily'] != null) {
      dailyDataSource = [];
      DateTime dailyDate = DateTime.now();
      for (var i = 0; i < 7; i++) {
        dailyDate = dailyDate.subtract(Duration(days: 1));
        String formattedDate = DateFormat('yyyy-MM-dd').format(dailyDate);

        dailyData['daily'].values.toList().forEach((data) {
          if (data['date'] == formattedDate) {
            dailyDataSource.add(
              DailyData(
                  dailyDate,
                  data['total']['confirmed'].toDouble(),
                  data['total']['active'].toDouble(),
                  data['total']['recovered'].toDouble(),
                  data['total']['deaths'].toDouble()),
            );
          }
        });
      }
    }
    if (dailyData['daily'] != null) {
      weeklyDataSource = [];
      DateTime weeklyDate = DateTime.now();
      for (var i = 0; i < 7; i++) {
        weeklyDate = weeklyDate.subtract(Duration(days: i == 0 ? 1 : 7));
        String formattedDate = DateFormat('yyyy-MM-dd').format(weeklyDate);

        dailyData['daily'].values.toList().forEach((data) {
          if (data['date'] == formattedDate) {
            weeklyDataSource.add(
              DailyData(
                  weeklyDate,
                  data['total']['confirmed'].toDouble(),
                  data['total']['active'].toDouble(),
                  data['total']['recovered'].toDouble(),
                  data['total']['deaths'].toDouble()),
            );
          }
        });
      }
    }
    if (dailyData['daily'] != null) {
      monthlyDataSource = [];
      DateTime monthlyDate = DateTime.now();
      for (var i = 0; i < 5; i++) {
        monthlyDate = monthlyDate.subtract(Duration(days: i == 0 ? 1 : 30));
        String formattedDate = DateFormat('yyyy-MM-dd').format(monthlyDate);
        print(formattedDate);
        dailyData['daily'].values.toList().forEach((data) {
          if (data['date'] == formattedDate) {
            monthlyDataSource.add(
              DailyData(
                  monthlyDate,
                  data['total']['confirmed'].toDouble(),
                  data['total']['active'].toDouble(),
                  data['total']['recovered'].toDouble(),
                  data['total']['deaths'].toDouble()),
            );
          }
        });
      }
    }
  }

  void _onRefresh() async {
    _refreshController.refreshCompleted();
    if (selectedCountry == null) {
      await getLatestGlobalData();
    } else {
      await getLatestCountryData();
    }
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    var latestData =
        selectedCountry != null ? latestCountryData : latestGlobalData;

    return Material(
      color: secondaryColor,
      child: Stack(
        children: [
          CurvedShape(),
          SmartRefresher(
            enablePullDown: true,
            header: WaterDropMaterialHeader(
              backgroundColor: secondaryColor,
              color: primaryColor,
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: Column(
              children: <Widget>[
                RefreshIndicatorText(),
                HeaderText(),
                CotrakCountryPicker(
                  selectedCountry: selectedCountry,
                  onCountryChange: _onCountryChange,
                ),
                HorizontalStatCards(
                    listViewController: listViewController,
                    dataCards: dataCards,
                    latestData: latestData,
                    dataCardsIcons: dataCardsIcons),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      dataTypeButton("total"),
                      dataTypeButton("daily"),
                      dataTypeButton("weekly"),
                      dataTypeButton("monthly")
                    ],
                  ),
                ),
                ChartsContainer(
                    dataType: dataType,
                    latestData: latestData,
                    dailyDataSource: dailyDataSource,
                    weeklyDataSource: weeklyDataSource,
                    monthlyDataSource: monthlyDataSource),
                NavBar(
                  selectedIndex: _selectedIndex,
                  onTabChange: _onTabChange,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  FlatButton dataTypeButton(title) {
    return FlatButton(
        onPressed: () {
          setState(() {
            dataType = title;
          });
          if (title == "daily") {
            getDailyData();
          }
        },
        color: dataType == title ? primaryColor : null,
        child: Text(
          '${title[0].toUpperCase()}${title.substring(1)}',
          style: TextStyle(
              color: dataType == title ? Colors.white : null, fontSize: 13),
        ));
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      selectedCountry = countryCode.code;
    });
    getLatestCountryData();
    getDailyData();
  }

  void _onTabChange(index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class NavBar extends StatelessWidget {
  const NavBar({
    Key key,
    @required this.selectedIndex,
    @required this.onTabChange,
  }) : super(key: key);

  final int selectedIndex;
  final onTabChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
      child: GNav(
          gap: 8,
          activeColor: Colors.white,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          duration: Duration(milliseconds: 500),
          tabBackgroundColor: primaryColor,
          tabs: [
            GButton(
              icon: LineIcons.bar_chart_o,
              text: 'Data',
            ),
            GButton(
              icon: LineIcons.newspaper_o,
              text: 'News',
            ),
            GButton(
              icon: LineIcons.heart_o,
              text: 'Charities',
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: onTabChange),
    );
  }
}
