import 'package:flutter/material.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  _WebViewContainerState createState() => _WebViewContainerState(url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

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
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          key: _key,
          initialUrlRequest: URLRequest(
            url: Uri.parse(_url),
          ),
          androidOnPermissionRequest: (InAppWebViewController controller,
              String origin, List<String> resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri.scheme)) {
              if (await canLaunch(_url)) {
                // Launch the App
                await launch(
                  _url,
                );
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }
            }

            return NavigationActionPolicy.ALLOW;
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
                      /*
                      Wrap(
                        children: [
                          Text(
                            'url:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            url.toString(),
                            maxLines: 3,
                            softWrap: true,
                          ),
                        ],
                      ),
                      */
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
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              mediaPlaybackRequiresUserGesture: false,
            ),
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            ),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
            ),
          ),
        ),
      ),
    );
  }
}
