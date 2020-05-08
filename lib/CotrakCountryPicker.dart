import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CotrakCountryPicker extends StatelessWidget {
  const CotrakCountryPicker(
      {Key key, @required this.selectedCountry, @required this.onCountryChange})
      : super(key: key);

  final selectedCountry;
  final onCountryChange;

  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      onChanged: onCountryChange,
      padding: EdgeInsets.only(top: 40),
      textStyle: TextStyle(color: Colors.white),
      showCountryOnly: true,
      favorite: ['IT', 'FR', 'US', 'SP', 'UK', 'DE', 'RU', 'TR', 'BR', 'IR'],
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
                selectedCountry != null
                    ? Container(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          color: Colors.white,
                          onPressed: () {
                            onCountryChange(null);
                          },
                          icon: Icon(
                            Icons.close,
                            size: 20,
                          ),
                        ),
                      )
                    : Container()
              ],
            ));
      },
    );
  }
}
