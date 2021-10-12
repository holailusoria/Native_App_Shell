import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'logic_builder.dart';

class WebViewContainer extends StatefulWidget {
  final syncPath;

  WebViewContainer(this.syncPath);

  @override
  _WebViewContainerState createState() => _WebViewContainerState(syncPath);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _key = UniqueKey();
  String? syncPath;

  InAppWebViewController? webViewController;

  InAppWebViewGroupOptions? options;

  _WebViewContainerState(this.syncPath);

  @override
  void initState() {
    options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        allowUniversalAccessFromFileURLs: true,
        //useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptCanOpenWindowsAutomatically: true,
        useShouldInterceptAjaxRequest: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
        allowsPictureInPictureMediaPlayback: true,
        isPagingEnabled: true,
      ),
    );
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
          initialOptions: options,
          initialFile: syncPath,
          onWebViewCreated: (InAppWebViewController controller) async {
            webViewController = controller;
          },
          androidOnPermissionRequest: (InAppWebViewController controller,
              String origin, List<String> resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          onAjaxProgress: (controller, ajax) async {
            print('ajax progress...');
            //print('ajax progress: $ajax');
            return AjaxRequestAction.PROCEED;
          },
          onAjaxReadyStateChange: (controller, ajax) async {
            print('ajax ready state changed: $ajax');
            print('AJAX RESPONSE TEXT: ' + ajax.responseText.toString());
            return AjaxRequestAction.PROCEED;
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
          onLoadStart: (InAppWebViewController controller, url) {},
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
          onLoadHttpError: (controller, url, code, message) {
            print('code: $code\n'
                'url: $url\n'
                'message: $message');
          },
          onLoadStop: (controller, url) async {
            print('load stopped: $url');
            print('progress: ' + (await controller.getProgress()).toString());
          },
          onLoadResource: (controller, loadedResources) {
            print('type: $loadedResources');
          },
          onProgressChanged: (controller, progress) {
            print('progress: $progress %');
          },
          iosOnNavigationResponse: (controller, response) async {
            print(response.response);
          },
          onDownloadStart: (controller, url) {
            print('Downloading started with url: $url');
          },
          onPrint: (controller, url) {
            print('onPrint event: $url');
          },
        ),
      ),
    );
  }
}
