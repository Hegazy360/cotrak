import 'package:cotrak/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (appLanguage.appLocal.toString() == "en") {
                    appLanguage.changeLanguage(Locale("ar"));
                  } else {
                    appLanguage.changeLanguage(Locale("en"));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: appLanguage.appLocal.toString() == "ar" ? 10 : 0,
                      right: appLanguage.appLocal.toString() == "en" ? 10 : 0),
                  child: Image.asset(
                      'icons/flags/png/${appLanguage.appLocal.toString() == "en" ? "gb" : "sa"}.png',
                      width: 30,
                      package: 'country_icons'),
                ),
              ),
              Text(
                "${AppLocalizations.of(context).translate('title')},",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            AppLocalizations.of(context).translate('subtitle'),
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
