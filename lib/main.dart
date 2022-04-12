import 'dart:io';
import 'src/utils/initializer.dart';
import 'src/web_view/logic_builder.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO add your permissions here:
  await Permission.storage.request();
  await initApp(pathToSettings: 'assets/ui_builder_app/settings.json');

  if (Platform.isAndroid) {
    //await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    //await Permission.locationAlways.request();
    //await Permission.location.request();
    //await Permission.locationWhenInUse.request();
  }

  runApp(StartPageStateless());
}
