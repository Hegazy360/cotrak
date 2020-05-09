import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CotrakCountryPicker extends StatelessWidget {
  const CotrakCountryPicker(
      {Key key,
      @required this.selectedCountry,
      @required this.onCountryChange,
      @required this.countries})
      : super(key: key);

  final selectedCountry;
  final onCountryChange;
  final countries;

  // void _onCountryChange(CountryCode countryCode) {
  //   if(countryCode != selectedCountry) {
  //     onCountryChange(country: countryCode == null ? null : countryCode.code);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // onCountryChange(country: "EG");
        showAsBottomSheet(context);
      },
      child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: selectedCountry != null && selectedCountry['alpha2code'] != null
                    ? Image.asset(
                        'icons/flags/png/${selectedCountry['alpha2code'].toLowerCase()}.png',
                        width: 30,
                        package: 'country_icons')
                    : Icon(
                        LineIcons.globe,
                        size: 24,
                        color: Colors.white,
                      ),
              ),
              Text(
                selectedCountry != null ? selectedCountry['name'] : "World",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              selectedCountry != null
                  ? Container(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        color: Colors.white,
                        onPressed: () {
                          onCountryChange(country: null);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    )
                  : Container()
            ],
          )),
    );
  }

  void showAsBottomSheet(context) async {
    await showSlidingBottomSheet(context, resizeToAvoidBottomInset: false,
        builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Material(
            child: Container(
              height: 500,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                physics: ClampingScrollPhysics(),
                itemCount: countries.length,
                itemBuilder: (_, i) {
                  return FlatButton(
                    onPressed: () {
                      onCountryChange(country: countries[i]);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: countries[i]['alpha2code'] != null
                              ? Image.asset(
                                  'icons/flags/png/${countries[i]['alpha2code'].toLowerCase()}.png',
                                  width: 30,
                                  package: 'country_icons')
                              : Icon(
                                  LineIcons.globe,
                                  size: 24,
                                  color: Colors.black,
                                ),
                        ),
                        Flexible(child: Text(countries[i]['name'])),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    });
  }
}
