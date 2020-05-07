import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding:
          const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
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
    );
  }
}
