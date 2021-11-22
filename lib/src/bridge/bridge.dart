import 'dart:convert';
import 'bridge_manager.dart';
import 'bridge_validator.dart';
import 'package:uuid/uuid.dart';
import '../types/system_events.dart';
import '../types/function_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Bridge {
  late InAppWebViewController controller;
  bool _isRegistered = false;

  Bridge({required this.controller});

  Future addWebMessageListener(
      {required String jsObjectName,
      Set<String>? allowedOriginRules,
      FunctionHandler? funcToRun}) async {
    this.controller.addWebMessageListener(WebMessageListener(
        jsObjectName: jsObjectName,
        allowedOriginRules: allowedOriginRules,
        onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) async {
          String result = '';
          try {
            Map data = jsonDecode(message!);

            if (funcToRun != null) {
              var ev = BridgeValidator.hasSystemEvent(data['message']);
              switch (ev) {
                case SystemEvents.REGISTER_FOR_PUSH:
                  if (_isRegistered) return;
                  result =
                      await BridgeManager.processFunc(() => funcToRun, data);
                  _isRegistered = true;
                  break;
                default:
                  result =
                      await BridgeManager.processFunc(() => funcToRun, data);
              }
            } else
              result = BridgeManager.buildResponse(
                  id: data['id']!, response: 'Processed');
          } catch (ex) {
            throw new Exception(ex);
          }
          replyProxy.postMessage(result);
        }));
  }

  Future dispatchEvent({required String type, required Map body}) async {
    //TODO: add id
    var uuid = Uuid();
    body['id'] = uuid.v5('', type);
    if (!body['id']) {
      throw new Exception('The body does not have\'id\' value');
    }
    String jsonBody = json.encode(body);
    await this.controller.evaluateJavascript(source: """
      window.dispatchEvent(new CustomEvent($type, {
        detail: $jsonBody}))
    """);
  }
}
