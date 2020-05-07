import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotrak/ChartsContainer.dart';
import 'package:cotrak/CotrakCountryPicker.dart';
import 'package:cotrak/DailyData.dart';
import 'package:cotrak/HeaderText.dart';
import 'package:cotrak/HorizontalStatCards.dart';
import 'package:cotrak/RefreshIndicator.dart';
import 'package:country_code_picker/country_code_picker.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

const primaryColor = Color(0xff15406C);
const primaryColorLight1 = Color(0xff2F5A86);
const primaryColorLight2 = Color(0xff48739F);
const primaryColorLight3 = Color(0xff628DB9);
const primaryColorLight4 = Color(0xff7BA6D2);
const secondaryColor = Color(0xffE8F0FB);

class StatsPage extends StatefulWidget {
  const StatsPage({
    Key key,
  }) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
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
  List<DailyData> dailyDataSource = [];
  List<DailyData> weeklyDataSource = [];
  List<DailyData> monthlyDataSource = [];

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
    var country;
    var sameAsCurrentCountry = false;
    if (selectedCountry != null) {
      country = countries
          .firstWhere((country) => selectedCountry == country['alpha2code']);
      sameAsCurrentCountry = dailyData.length > 0 &&
          dailyData['daily'].values.first['country'] == country['name'];
    } else {
      country = {'name': "World"};
      sameAsCurrentCountry = dailyData.length > 0 &&
          dailyData['daily'].values.first['country'] == null;
    }

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
      weeklyDataSource = [];
      monthlyDataSource = [];
      var confirmed, active, recovered, deaths;

      DateTime dailyDate = DateTime.now();
      for (var i = 0; i < 7; i++) {
        dailyDate = dailyDate.subtract(Duration(days: 1));
        String formattedDate = DateFormat('yyyy-MM-dd').format(dailyDate);

        dailyData['daily'].values.toList().forEach((data) {
          if (data['date'] == formattedDate) {
            if (selectedCountry != null) {
              confirmed = data['total']['confirmed'].toDouble();
              active = data['total']['active'].toDouble();
              recovered = data['total']['recovered'].toDouble();
              deaths = data['total']['deaths'].toDouble();
            } else {
              confirmed = data['confirmed'].toDouble();
              active = data['active'].toDouble();
              recovered = data['recovered'].toDouble();
              deaths = data['deaths'].toDouble();
            }
            dailyDataSource.add(
                DailyData(dailyDate, confirmed, active, recovered, deaths));
          }
        });
      }
      DateTime weeklyDate = DateTime.now();
      for (var i = 0; i < 7; i++) {
        weeklyDate = weeklyDate.subtract(Duration(days: i == 0 ? 1 : 7));
        String formattedDate = DateFormat('yyyy-MM-dd').format(weeklyDate);

        dailyData['daily'].values.toList().forEach((data) {
          if (data['date'] == formattedDate) {
            if (selectedCountry != null) {
              confirmed = data['total']['confirmed'].toDouble();
              active = data['total']['active'].toDouble();
              recovered = data['total']['recovered'].toDouble();
              deaths = data['total']['deaths'].toDouble();
            } else {
              confirmed = data['confirmed'].toDouble();
              active = data['active'].toDouble();
              recovered = data['recovered'].toDouble();
              deaths = data['deaths'].toDouble();
            }
            weeklyDataSource.add(
                DailyData(weeklyDate, confirmed, active, recovered, deaths));
          }
        });
      }
      print("---------------------");
      DateTime monthlyDate = DateTime.now();
      for (var i = 0; i < 5; i++) {
        monthlyDate = monthlyDate.subtract(Duration(days: i == 0 ? 1 : 30));
        String formattedDate = DateFormat('yyyy-MM-dd').format(monthlyDate);
        dailyData['daily'].values.toList().forEach((data) {
          if (data['date'] == formattedDate) {
            if (selectedCountry != null) {
              confirmed = data['total']['confirmed'].toDouble();
              active = data['total']['active'].toDouble();
              recovered = data['total']['recovered'].toDouble();
              deaths = data['total']['deaths'].toDouble();
            } else {
              confirmed = data['confirmed'].toDouble();
              active = data['active'].toDouble();
              recovered = data['recovered'].toDouble();
              deaths = data['deaths'].toDouble();
            }
            monthlyDataSource.add(
                DailyData(monthlyDate, confirmed, active, recovered, deaths));
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

    return SmartRefresher(
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
          getDailyData();
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
      selectedCountry = countryCode == null ? null : countryCode.code;
    });
    if(countryCode == null) {
      getLatestGlobalData();
    } else {
      getLatestCountryData();
    }
    getDailyData();
  }
}
