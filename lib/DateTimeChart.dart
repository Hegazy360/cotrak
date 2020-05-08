
import 'package:cotrak/DailyData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

const primaryColor = Color(0xff15406C);
const primaryColorLight1 = Color(0xff2F5A86);
const primaryColorLight2 = Color(0xff48739F);
const primaryColorLight3 = Color(0xff628DB9);
const primaryColorLight4 = Color(0xff7BA6D2);
const secondaryColor = Color(0xffE8F0FB);

class DateTimeChart extends StatelessWidget {
  const DateTimeChart({
    Key key,
    @required this.dateSource,
  }) : super(key: key);

  final List<DailyData> dateSource;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        legend: Legend(
            position: LegendPosition.bottom,
            isVisible: true,
            toggleSeriesVisibility: true),
        plotAreaBorderWidth: 0,
        margin: EdgeInsets.only(left: 5, right: 5,bottom: 10),
        palette: <Color>[
          primaryColorLight1,
          primaryColorLight2,
          primaryColorLight3,
          primaryColorLight4,
        ],
        primaryXAxis: DateTimeAxis(
          majorGridLines: MajorGridLines(
            width: 0,
          ),
        ),
        primaryYAxis:
            NumericAxis(isVisible: false, numberFormat: NumberFormat.compact()),
        series: <CartesianSeries>[
          ColumnSeries<DailyData, DateTime>(
            name: 'Confirmed',
            dataSource: dateSource,
            xValueMapper: (DailyData data, _) => data.date,
            yValueMapper: (DailyData data, _) => data.confirmed,
            dataLabelSettings: DataLabelSettings(
                color: primaryColor,
                textStyle: ChartTextStyle(fontWeight: FontWeight.w500),
                isVisible: true),
            trendlines: <Trendline>[
              Trendline(
                  isVisibleInLegend: false,
                  type: TrendlineType.polynomial,
                  color: primaryColor)
            ],
          ),
          ColumnSeries<DailyData, DateTime>(
            name: 'Active',
            dataSource: dateSource,
            xValueMapper: (DailyData data, _) => data.date,
            yValueMapper: (DailyData data, _) => data.active,
            trendlines: <Trendline>[
              Trendline(
                  isVisibleInLegend: false,
                  type: TrendlineType.polynomial,
                  color: Colors.blueGrey[200])
            ],
          ),
          ColumnSeries<DailyData, DateTime>(
            name: 'Recovered',
            dataSource: dateSource,
            xValueMapper: (DailyData data, _) => data.date,
            yValueMapper: (DailyData data, _) => data.recovered,
            trendlines: <Trendline>[
              Trendline(
                  isVisibleInLegend: false,
                  type: TrendlineType.polynomial,
                  color: Colors.blueGrey[200])
            ],
          ),
          ColumnSeries<DailyData, DateTime>(
            name: 'Deaths',
            dataSource: dateSource,
            xValueMapper: (DailyData data, _) => data.date,
            yValueMapper: (DailyData data, _) => data.deaths,
            trendlines: <Trendline>[
              Trendline(
                  isVisibleInLegend: false,
                  type: TrendlineType.polynomial,
                  color: Colors.blueGrey[200])
            ],
          ),
        ]);
  }
}
