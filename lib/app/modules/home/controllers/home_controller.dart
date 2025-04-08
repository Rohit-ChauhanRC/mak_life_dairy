import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:webview_mak_inapp/app/constants/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeController extends GetxController {
  //
  final GlobalKey webViewKey = GlobalKey();

  static final box = GetStorage();
  final downloadManager = DownloadManager();

  // var no = box.read(Constants.cred);

  final RxString _mobileNumber = ''.obs;
  String get mobileNumber => _mobileNumber.value;
  set mobileNumber(String mobileNumber) => _mobileNumber.value = mobileNumber;

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  final RxDouble _progress = 0.0.obs;
  double get progress => _progress.value;
  set progress(double i) => _progress.value = i;

  // WebViewController webViewController = WebViewController();

  InAppWebViewController? webViewController;

  final ReceivePort _port = ReceivePort();

  // https://play.google.com/store/apps/details?id=com.genmak.mak_life_dairy_fresh&hl=en_IN

  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      clearCache: false,
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: true,
      allowsInlineMediaPlayback: true,
      iframeAllow:
          "camera; microphone;storage;mediaLibrary;photosAddOnly;Photos",
      iframeAllowFullscreen: true,
      allowFileAccessFromFileURLs: true,
      allowContentAccess: true,
      allowFileAccess: true,
      allowsBackForwardNavigationGestures: true,
      useOnDownloadStart: true,
      allowUniversalAccessFromFileURLs: true,
      javaScriptEnabled: true,
      useOnLoadResource: true);

  PullToRefreshController? pullToRefreshController;

  Future<void> permisions() async {
    await Permission.storage.request();
    await Permission.camera.request();
    await Permission.mediaLibrary.request();
    await Permission.microphone.request();
    await Permission.photos.request();
    await Permission.notification.request();
    await Permission.manageExternalStorage.request();
  }

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    mobileNumber = box.read(Constants.cred) ?? Get.arguments;
    await permisions();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> downloadFile(String url, [String? filename]) async {
    var hasStoragePermission = await Permission.storage.isGranted;
    if (!hasStoragePermission) {
      final status = await Permission.storage.request();
      hasStoragePermission = status.isGranted;
    }
    if (hasStoragePermission) {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        headers: {},
        // optional: header send with url (auth token etc)
        savedDir: (await getApplicationDocumentsDirectory()).path,
        saveInPublicStorage: true,
        showNotification: false,
        openFileFromNotification: true,
        fileName: filename,
        allowCellular: true,
      );

      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text("Download $filename completed!"),
      ));
    }
  }

  Future<String> downloadAndOpenPdf(String url) async {
    debugPrint("url: $url");
    try {
      // Get the application documents directory
      Directory dir = await getApplicationDocumentsDirectory();
      String fileName = url
          .split('/')
          .last; // Extract filename from URL (last part of the URL)

      if (fileName.isEmpty) {
        // If filename is empty or invalid, fall back to a default name
        fileName = 'downloaded.pdf';
      }

      String filePath = "${dir.path}/$fileName.pdf";
      debugPrint("Downloading to: $filePath");

      // Create Dio instance and download the file
      Dio dio = Dio();
      await dio.download(url, filePath);

      // Open the downloaded file
      // await OpenFile.open(filePath);
      debugPrint("PDF Downloaded and Opened!");
      return filePath;
    } catch (e) {
      throw Exception(e);
    }
  }
}
