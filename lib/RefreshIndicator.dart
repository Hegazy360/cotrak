import 'package:flutter/material.dart';

class RefreshIndicatorText extends StatelessWidget {
  const RefreshIndicatorText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
