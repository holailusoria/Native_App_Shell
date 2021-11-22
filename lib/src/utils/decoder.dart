import 'dart:convert';
import '../types/system_events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class Decoder {
  static String decodeEnum(SystemEvents se) {
    return describeEnum(se).toLowerCase().replaceAll('_', ' ');
  }

  static Future<dynamic> readJson() async {
    final String response =
        await rootBundle.loadString('assets/ui_builder_app/settings.json');
    final data = await json.decode(response);

    return data;
  }
}
