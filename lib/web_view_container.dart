import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final name;

  WebViewContainer(this.url, this.name);

  @override
  _WebViewContainerState createState() => _WebViewContainerState(url, name);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  var _name;
  final _key = UniqueKey();
  bool _showAppBar = true;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  _WebViewContainerState(this._url, this._name);

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onScrollYChanged.listen((offsetY) {
      if (offsetY > 10)
        appBarStatus(false);
      else
        appBarStatus(true);
    });
  }

  void appBarStatus(bool status) {
    setState(() {
      _showAppBar = status;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SwipeDetector(
        child: WebviewScaffold(
          key: _key,
          url: _url,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AnimatedContainer(
              height: _showAppBar ? 55.0 : 0.0,
              duration: Duration(milliseconds: 400),
              child: AppBar(
                backgroundColor: Colors.grey.shade500,
                title: _name == null || _name == '' ? Text('') : Text(_name),
              ),
            ),
          ),
        ),
        onSwipeUp: () {
          appBarStatus(false);
        },
        swipeConfiguration: SwipeConfiguration(
            verticalSwipeMinVelocity: 70.0,
            verticalSwipeMinDisplacement: 50.0,
            verticalSwipeMaxWidthThreshold: 100.0,
            horizontalSwipeMaxHeightThreshold: 50.0,
            horizontalSwipeMinDisplacement: 50.0,
            horizontalSwipeMinVelocity: 200.0),
      ),
    );
  }
}
