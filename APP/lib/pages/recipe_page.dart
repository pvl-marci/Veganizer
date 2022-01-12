import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

final webViewKey = GlobalKey<WebViewContainerState>();

class WebViewContainer extends StatefulWidget {
  WebViewContainer(this.stream);
  final Stream<String> stream;

  @override
  WebViewContainerState createState() => WebViewContainerState();
}

class WebViewContainerState extends State<WebViewContainer> {
  late WebViewController _webViewController;

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Congratulations!"),
          content: new Text("With this meal you created 91% less CO2!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String url = "";

  void initState() {
    super.initState();
    widget.stream.listen((url) {
      mySetState(url);
    });
  }

  void mySetState(String url) {
    setState(() {
      _webViewController.loadUrl(url);
      _showDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      initialUrl: "",
    );
  }

  void reloadWebView() {
    _webViewController.reload();
  }
}
