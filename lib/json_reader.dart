import 'dart:convert';
import 'package:flutter/services.dart';

Future<dynamic> readJson() async {
  final String response =
      await rootBundle.loadString('assets/ui_builder_app/settings.json');
  final data = await json.decode(response);

  return data;
}
