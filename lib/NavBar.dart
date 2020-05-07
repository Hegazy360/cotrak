import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

const primaryColor = Color(0xff15406C);
const primaryColorLight1 = Color(0xff2F5A86);
const primaryColorLight2 = Color(0xff48739F);
const primaryColorLight3 = Color(0xff628DB9);
const primaryColorLight4 = Color(0xff7BA6D2);
const secondaryColor = Color(0xffE8F0FB);

class NavBar extends StatelessWidget {
  const NavBar({
    Key key,
    @required this.selectedIndex,
    @required this.onTabChange,
  }) : super(key: key);

  final int selectedIndex;
  final onTabChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
          selectedIndex: selectedIndex,
          onTabChange: onTabChange),
    );
  }
}
