import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final title;
  WebViewContainer(this.url, this.title);
  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Material(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text(
        //     widget.title,
        //     style: TextStyle(color: Colors.black, fontSize: 12),
        //   ),
        //   leading: BackButton(
        //     color: Colors.black,
        //   ),
        // ),
        child: Column(
      children: [
        Expanded(
            child: WebView(
                key: _key,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: widget.url)),
        Container(
          width: MediaQuery.of(context).size.width,
          child: FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
            label: Text(widget.title),
          ),
        )
      ],
    ));
  }
}
