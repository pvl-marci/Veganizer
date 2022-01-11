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
