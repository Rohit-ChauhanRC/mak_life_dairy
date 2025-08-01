import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:webview_mak_inapp/app/constants/constants.dart';
import 'package:webview_mak_inapp/http_override.dart';

import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

const platform = MethodChannel('com.genmak.makLifeDairyFresh/channel');

Future<void> enableWebKit() async {
  try {
    await platform.invokeMethod('enableWebKit');
  } on PlatformException catch (e) {
    print("Failed to enable WebKit: '${e.message}'.");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = DevHttpOverrides();
  await GetStorage.init();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  final box = GetStorage();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appbarTitle,
      initialRoute:
          box.read(Constants.cred) != null ? AppPages.CHECK : AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
