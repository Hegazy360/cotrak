import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const primaryColor = Color(0xff15406C);
const primaryColorLight1 = Color(0xff2F5A86);
const primaryColorLight2 = Color(0xff48739F);
const primaryColorLight3 = Color(0xff628DB9);
const primaryColorLight4 = Color(0xff7BA6D2);
const secondaryColor = Color(0xffE8F0FB);

class HorizontalStatCards extends StatelessWidget {
  const HorizontalStatCards({
    Key key,
    @required this.listViewController,
    @required this.dataCards,
    @required this.latestData,
    @required this.dataCardsIcons, @required this.dailyData,
  }) : super(key: key);

  final ScrollController listViewController;
  final List<String> dataCards;
  final Map latestData;
  final Map dailyData;
  final List<IconData> dataCardsIcons;

  @override
  Widget build(BuildContext context) {
    Card statCard(title, value, icon) {
      return Card(
          color: Color(0xffF9FAFE),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: primaryColor),
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

    return Padding(
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
              itemCount: 5,
              itemBuilder: (_, i) {
                if(i == 1 && dailyData['daily'] != null && latestData['confirmed'] != null) {
                  DateTime dailyDate = DateTime.now().subtract(Duration(days: 1));
                  String formattedDate = DateFormat('yyyy-MM-dd').format(dailyDate);
                  var yesterdayStat = dailyData['daily'].values.toList().firstWhere((element) => element['date'] == formattedDate);
                  var value = latestData['confirmed'] - yesterdayStat['confirmed'];

                  return statCard(
                    dataCards[i], value, dataCardsIcons[i]);
                }
                return statCard(
                    dataCards[i], latestData[dataCards[i]], dataCardsIcons[i]);
              },
            )),
      ),
    );
  }
}
