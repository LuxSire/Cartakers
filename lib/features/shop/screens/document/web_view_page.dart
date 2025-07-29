import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb check
import 'package:webview_flutter/webview_flutter.dart'; // For mobile (iOS & Android)
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart'; // For WebView Plugin on Web and Desktop

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller =
          WebViewController()
            ..loadRequest(Uri.parse(widget.url)); // For iOS and Android
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.url)),
      body:
          kIsWeb
              ? WebviewScaffold(
                // For Web
                url: widget.url,
                withZoom: true,
                withLocalStorage: true,
              )
              : WebViewWidget(
                controller: _controller,
              ), // For mobile iOS/Android
    );
  }
}
