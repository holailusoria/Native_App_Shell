import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  _WebViewContainerState createState() => _WebViewContainerState(url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  _WebViewContainerState(this._url);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebviewScaffold(
        key: _key,
        url: _url,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AnimatedContainer(
            height: 0.0,
            duration: Duration(milliseconds: 400),
            child: AppBar(),
          ),
        ),
      ),
    );
  }
}
