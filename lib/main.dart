import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'logic_builder.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Permission.storage.request();
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(StartPageStateless());
}
