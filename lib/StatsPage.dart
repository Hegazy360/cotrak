import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotrak/ChartsContainer.dart';
import 'package:cotrak/CotrakCountryPicker.dart';
import 'package:cotrak/DailyData.dart';
import 'package:cotrak/HeaderText.dart';
import 'package:cotrak/HorizontalStatCards.dart';
import 'package:cotrak/RefreshIndicator.dart';
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
  var latestData = {};
  var dailyData = {};
  var yesterdaysCases = 0;

  var dataCards = ['confirmed', 'today', 'critical', 'deaths', 'recovered'];
  List countries = [];
  var dataCardsIcons = [
    LineIcons.check,
    LineIcons.plus,
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
    getAllCountries();
    updateAllData();
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

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
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

  updateAllData({country, resetListViewController: true}) async {
    var tempLatestData, tempDailyData;

    if (country != null) {
      tempLatestData = await getLatestCountryData(country['alpha2code']);
    } else {
      tempLatestData = await getLatestGlobalData();
    }

    tempDailyData = await getDailyData(country != null? country : null);

    var decodedTempLatestData = json.decode(tempLatestData.body);

    setState(() {
      latestData = decodedTempLatestData.length > 0 ? decodedTempLatestData[0] : {};
      dailyData = tempDailyData.data;
      selectedCountry = country;

      updateDailyChartData(tempDailyData.data);
    });

    if (resetListViewController) {
      listViewController.animateTo(0.0,
          curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
    }
  }

  Future getLatestGlobalData() {
    final response = http.get(
      'https://covid-19-data.p.rapidapi.com/totals?format=json',
      headers: {
        "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
        "x-rapidapi-key": "kobRJjesp4mshawkaj0YnlruOFmKp137FOGjsnwtgFFV9t5Lso"
      },
    );

    return response;
  }

  Future getLatestCountryData(country) {
    final response = http.get(
      'https://covid-19-data.p.rapidapi.com/country/code?code=$country&format=json',
      headers: {
        "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
        "x-rapidapi-key": "kobRJjesp4mshawkaj0YnlruOFmKp137FOGjsnwtgFFV9t5Lso"
      },
    );

    return response;
  }

  Future getDailyData(country) {
    if (country == null) {
      country = {'name': "World"};
    }

    DocumentReference statsRef =
        Firestore.instance.collection("stats").document(country['name']);
    Future<DocumentSnapshot> getDoc = statsRef.get();

    return getDoc;
  }

  setPeriodicChartData(sourceType, count, incrementRate) {
    var confirmed, active, recovered, deaths;
    DateTime dailyDate = DateTime.now();
    bool hasBeenShifted = false;
    bool dateFound = false;

    for (var i = 0; i < count; i++) {
      dateFound = false;
      dailyDate =
          dailyDate.subtract(Duration(days: i == 0 ? 1 : incrementRate));
      String formattedDate = DateFormat('yyyy-MM-dd').format(dailyDate);

      dailyData['daily'].values.toList().forEach((data) {
        if (data['date'] == formattedDate) {
          dateFound = true;
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
          if (sourceType == "daily") {
            if (i == 0) {
              yesterdaysCases = confirmed.toInt();
            }
            dailyDataSource.add(
                DailyData(dailyDate, confirmed, active, recovered, deaths));
          }
          if (sourceType == "weekly") {
            weeklyDataSource.add(
                DailyData(dailyDate, confirmed, active, recovered, deaths));
          }
          if (sourceType == "monthly") {
            monthlyDataSource.add(
                DailyData(dailyDate, confirmed, active, recovered, deaths));
          }
        }
      });
      if (!dateFound && i == 0 && !hasBeenShifted) {
        i--;
        hasBeenShifted = true;
      }
    }
  }

  updateDailyChartData(dailyData) {
    if (dailyData['daily'] != null) {
      dailyDataSource = [];
      weeklyDataSource = [];
      monthlyDataSource = [];
      setPeriodicChartData("daily", 7, 1);
      setPeriodicChartData("weekly", 7, 7);
      setPeriodicChartData("monthly", 5, 30);
    }
  }

  void _onRefresh() async {
    _refreshController.refreshCompleted();
    updateAllData();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
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
            onCountryChange: updateAllData,
            countries: countries,
          ),
          HorizontalStatCards(
              listViewController: listViewController,
              dataCards: dataCards,
              latestData: latestData,
              todaysCases: latestData['confirmed'] != null
                  ? latestData['confirmed'] - yesterdaysCases
                  : null,
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
        },
        color: dataType == title ? primaryColor : null,
        child: Text(
          '${title[0].toUpperCase()}${title.substring(1)}',
          style: TextStyle(
              color: dataType == title ? Colors.white : null, fontSize: 13),
        ));
  }
}
