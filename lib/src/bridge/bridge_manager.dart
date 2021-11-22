import 'dart:convert';

class BridgeManager {
  static Future<String> processFunc(Function() func, Map data) async {
    var result;
    try {
      func().call().then((value) {
        result = buildResponse(
          id: data['id']!,
          response: value,
        );
      }, onError: (error) {
        result = buildResponse(
          id: data['id']!,
          error: data['error'] != null ? data['error'] : error,
        );
      });
    } catch (ex) {
      throw new Exception(ex);
    }
    await Future.delayed(Duration(seconds: 10));
    return result;
  }

  static String buildResponse(
      {required String id, dynamic response, String? error}) {
    Map result = Map();
    result['id'] = id;

    if (response != null)
      result['result'] = json.encode(response);
    else
      result['error'] = json.encode(error);

    try {
      return json.encode(result);
    } catch (ex) {
      throw new Exception(ex);
    }
  }
}
