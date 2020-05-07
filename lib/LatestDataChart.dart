import 'package:cotrak/LatestData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

const primaryColor = Color(0xff15406C);
const primaryColorLight1 = Color(0xff2F5A86);
const primaryColorLight2 = Color(0xff48739F);
const primaryColorLight3 = Color(0xff628DB9);
const primaryColorLight4 = Color(0xff7BA6D2);
const secondaryColor = Color(0xffE8F0FB);

class LatestDataChart extends StatelessWidget {
  const LatestDataChart({
    Key key,
    @required this.latestData,
  }) : super(key: key);

  final Map latestData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: EdgeInsets.only(bottom: 10),
        palette: <Color>[primaryColor.withOpacity(0.7)],
        primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(
            width: 0,
          ),
        ),
        primaryYAxis:
            NumericAxis(isVisible: false, numberFormat: NumberFormat.compact()),
        series: <ChartSeries>[
          // Initialize line series
          ColumnSeries<LatestData, String>(
              dataSource: [
                // Bind data source
                LatestData(
                    "Confirmed",
                    latestData["confirmed"] != null
                        ? latestData["confirmed"].toDouble()
                        : 0.0),
                LatestData(
                    "Recovered",
                    latestData["recovered"] != null
                        ? latestData["recovered"].toDouble()
                        : 0.0),
                LatestData(
                    "Deaths",
                    latestData["deaths"] != null
                        ? latestData["deaths"].toDouble()
                        : 0.0),
                LatestData(
                    "Critical",
                    latestData["critical"] != null
                        ? latestData["critical"].toDouble()
                        : 0.0),
              ],
              xValueMapper: (LatestData sales, _) => sales.type,
              yValueMapper: (LatestData sales, _) => sales.value,
              dataLabelSettings: DataLabelSettings(
                  color: primaryColor,
                  textStyle: ChartTextStyle(fontWeight: FontWeight.w500),
                  isVisible: true)),
        ]);
  }
}
