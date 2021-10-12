import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:native_app_shell/web_view_container.dart';
import 'dart:io' as io;

class StartPageStateless extends StatelessWidget {
  //TODO Set path to your 'index.html' file!
  var syncPath = '/Users/default/StudioProjects/native_app_shell/lib/main.dart';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isExists() //&& appUrl.contains('backendless')
            ? WebViewContainer(syncPath)
            : StartPageStateful());
  }

  bool isExists() {
    return io.File(syncPath).existsSync();
  }
}

class StartPageStateful extends StatefulWidget {
  const StartPageStateful({Key? key}) : super(key: key);

  @override
  _StartPageStatefulState createState() => _StartPageStatefulState();
}

class _StartPageStatefulState extends State<StartPageStateful> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 120.0),
          child: Image.asset(
            'images/backendless_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Please enter the path to the \'index.html\' file in \'syncPath\' variable',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InAppWebViewLocal extends StatefulWidget {
  const InAppWebViewLocal({Key? key}) : super(key: key);

  @override
  _InAppWebViewLocalState createState() => _InAppWebViewLocalState();
}

class _InAppWebViewLocalState extends State<InAppWebViewLocal> {
  var _url;
  final _key = UniqueKey();

  InAppWebViewController? webViewController;

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
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          key: _key,
          initialFile: 'flutter_app/index.html',
          androidOnPermissionRequest: (InAppWebViewController controller,
              String origin, List<String> resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
          onLoadError: (controller, url, code, message) {
            print('code: $code\n'
                'url: $url\n'
                'message: $message');
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                titlePadding: EdgeInsets.all(8.0),
                insetPadding: EdgeInsets.symmetric(horizontal: 8.0),
                contentPadding: EdgeInsets.all(8.0),
                title: Text('Error'),
                content: Container(
                  //width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Text(
                            'code:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            code.toString(),
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          Text(
                            'message:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            message,
                            maxLines: 10,
                            softWrap: true,
                          ),
                          Text(
                            '\nTry restarting the app',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                scrollable: true,
              ),
            );
          },
          onWebViewCreated: (InAppWebViewController controller) {
            webViewController = controller;
          },
        ),
      ),
    );
  }
}
