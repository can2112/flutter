import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWebView(),
    );
  }
}

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onmeta Example'),
      ),
      body: WebView(
        initialUrl:
            'https://p2xvk012-3000.inc1.devtunnels.ms/?apiKey=6af803df-0e0e-4708-805f-87baa8653e97', // Set the initial URL here
        javascriptMode: JavascriptMode.unrestricted, // Enable JavaScript
      ),
    );
  }
}
