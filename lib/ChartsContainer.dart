import 'package:cotrak/DailyData.dart';
import 'package:cotrak/DateTimeChart.dart';
import 'package:cotrak/LatestDataChart.dart';
import 'package:flutter/material.dart';

class ChartsContainer extends StatelessWidget {
  const ChartsContainer({
    Key key,
    @required this.dataType,
    @required this.latestData,
    @required this.dailyDataSource,
    @required this.weeklyDataSource,
    @required this.monthlyDataSource,
  }) : super(key: key);

  final String dataType;
  final Map latestData;
  final List<DailyData> dailyDataSource;
  final List<DailyData> weeklyDataSource;
  final List<DailyData> monthlyDataSource;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: dataType == "total"
                ? LatestDataChart(latestData: latestData)
                : dataType == "daily"
                    ? DateTimeChart(dateSource: dailyDataSource)
                    : dataType == "weekly"
                        ? DateTimeChart(dateSource: weeklyDataSource)
                        : DateTimeChart(
                            dateSource: monthlyDataSource,
                          )));
  }
}
