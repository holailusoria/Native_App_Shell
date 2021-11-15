import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:overlay_support/overlay_support.dart';
import 'json_reader.dart';

Future<void> initApp() async {
  kNotificationSlideDuration = const Duration(milliseconds: 500);
  kNotificationDuration = const Duration(milliseconds: 1500);

  final initData = await readJson();
  await Backendless.initApp(
    applicationId: initData['appId'],
    androidApiKey: initData['apiKey'],
    iosApiKey: initData['apiKey'],
  );
  await Backendless.setUrl(initData['serverURL']);
}