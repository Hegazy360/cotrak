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
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:line_icons/line_icons.dart';

const CURVE_HEIGHT = 300.0;
const primaryColor = Color(0xff15406C);
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
  var dailyGlobalData = {};
  var dataCards = ['confirmed', 'critical', 'deaths', 'recovered'];
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
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          SystemChrome.setEnabledSystemUIOverlays([]);
        }
      },
    );
    super.initState();
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

  getDailyGlobalData() async {
    final response = await http.get(
      'https://covid-19-data.p.rapidapi.com/report/totals?date=2020-05-04&date-format=YYYY-MM-DD&format=json',
      headers: {
        "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
        "x-rapidapi-key": "kobRJjesp4mshawkaj0YnlruOFmKp137FOGjsnwtgFFV9t5Lso"
      },
    );
    final responseJson = json.decode(response.body);

    setState(() {
      latestGlobalData = responseJson[0];
    });
    listViewController.animateTo(0.0,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
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
    return Material(
      color: secondaryColor,
      child: Stack(
        children: [
          CurvedShape(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
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
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Pull to refresh",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hello,",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Here's the latest Covid-19 news",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          CountryCodePicker(
            onChanged: _onCountryChange,
            padding: EdgeInsets.only(top: 40),
            textStyle: TextStyle(color: Colors.white),
            showCountryOnly: true,
            favorite: [
              'IT',
              'FR',
              'US',
              'SP',
              'UK',
              'DE',
              'RU',
              'TR',
              'BR',
              'IR'
            ],
            showOnlyCountryWhenClosed: true,
            comparator: (a, b) => b.name.compareTo(a.name),
            builder: (countryCode) {
              return Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: selectedCountry != null
                            ? Image.asset(
                                countryCode.flagUri,
                                package: 'country_code_picker',
                                width: 30,
                              )
                            : Icon(
                                LineIcons.globe,
                                size: 24,
                                color: Colors.white,
                              ),
                      ),
                      Text(
                        selectedCountry != null ? countryCode.name : "World",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: SizedBox(
              height: 200,
              child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return false;
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: listViewController,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    physics: ClampingScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (_, i) {
                      return statCard(dataCards[i], latestData[dataCards[i]],
                          dataCardsIcons[i]);
                    },
                  )),
            ),
          ),
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
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: dataType == "total"
                    ? SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        margin: EdgeInsets.only(bottom: 10),
                        palette: <Color>[primaryColor.withOpacity(0.7)],
                        primaryXAxis: CategoryAxis(
                          majorGridLines: MajorGridLines(
                            width: 0,
                          ),
                        ),
                        primaryYAxis: NumericAxis(
                            isVisible: false,
                            numberFormat: NumberFormat.compact()),
                        series: <ChartSeries>[
                          // Initialize line series
                          ColumnSeries<ChartData, String>(
                              dataSource: [
                                // Bind data source
                                ChartData(
                                    "Confirmed",
                                    latestData["confirmed"] != null
                                        ? latestData["confirmed"].toDouble()
                                        : 0.0),
                                ChartData(
                                    "Recovered",
                                    latestData["recovered"] != null
                                        ? latestData["recovered"].toDouble()
                                        : 0.0),
                                ChartData(
                                    "Deaths",
                                    latestData["deaths"] != null
                                        ? latestData["deaths"].toDouble()
                                        : 0.0),
                                ChartData(
                                    "Critical",
                                    latestData["critical"] != null
                                        ? latestData["critical"].toDouble()
                                        : 0.0),
                              ],
                              xValueMapper: (ChartData sales, _) => sales.type,
                              yValueMapper: (ChartData sales, _) => sales.value,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              dataLabelSettings: DataLabelSettings(
                                  color: primaryColor,
                                  textStyle: ChartTextStyle(
                                      fontWeight: FontWeight.w500),
                                  isVisible: true)),
                        ])
                    : SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        margin: EdgeInsets.only(bottom: 10),
                        palette: <Color>[primaryColor.withOpacity(0.7)],
                        primaryXAxis: DateTimeAxis(
                          majorGridLines: MajorGridLines(
                            width: 0,
                          ),
                        ),
                        primaryYAxis: NumericAxis(
                            isVisible: false,
                            numberFormat: NumberFormat.compact()),
                        series: <ChartSeries>[
                          SplineSeries<SalesData, DateTime>(
                              dataSource: [
                                SalesData(DateTime.now().subtract(Duration(days: 5)), 200),
                                SalesData(DateTime.now().subtract(Duration(days: 4)), 338),
                                SalesData(DateTime.now().subtract(Duration(days: 3)), 424),
                                SalesData(DateTime.now().subtract(Duration(days: 2)), 200),
                                SalesData(DateTime.now().subtract(Duration(days: 1)), 145)
                              ],
                              animationDuration: 3,
                              xValueMapper: (SalesData sales, _) => sales.year,
                              yValueMapper: (SalesData sales, _) => sales.sales)
                        ])),
          ),
          Padding(
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
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
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

  Card statCard(title, value, icon) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          height: 170,
          width: MediaQuery.of(context).size.width / 3 - 20,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${title[0].toUpperCase()}${title.substring(1)}',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: primaryColor),
              ),
              Icon(
                icon,
                size: 35,
                color: primaryColor,
              ),
              Text(
                value != null ? NumberFormat.compact().format(value) : '—',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: primaryColor),
              )
            ],
          ),
        ));
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      selectedCountry = countryCode.code;
    });
    getLatestCountryData();
  }
}

class ChartData {
  ChartData(this.type, this.value);
  final String type;
  final double value;
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: CURVE_HEIGHT,
      child: CustomPaint(
        painter: _MyPainter(),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = primaryColor;

    Path path = Path();
    path.lineTo(0, size.height);

    path.quadraticBezierTo(
        size.width / 2, size.height + 100, size.width, size.height + 50);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
