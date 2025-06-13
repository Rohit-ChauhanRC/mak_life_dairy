import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:webview_mak_inapp/app/constants/constants.dart';
import 'package:webview_mak_inapp/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:upgrader/upgrader.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      barrierDismissible: false,
      shouldPopScope: () => false,
      dialogStyle: UpgradeDialogStyle.cupertino,
      showIgnore: false,
      showLater: false,
      showReleaseNotes: true,
      upgrader: Upgrader(
        minAppVersion: Platform.isIOS ? "2.2" : "20.0.0",
        debugLogging: true,
        durationUntilAlertAgain: const Duration(seconds: 1),
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (await controller.webViewController?.canGoBack() ?? false) {
            controller.webViewController?.goBack();
          } else {
            SystemNavigator
                .pop(); // or use Get.back() if you’re using nested routes
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                InAppWebView(
                  onCameraCaptureStateChanged:
                      (controller, oldState, newState) async {},
                  key: controller.webViewKey,
                  initialUrlRequest: URLRequest(
                      url: WebUri(
                          "https://app.maklifedairy.in:5017/index.php/Login/Check_Login/${controller.mobileNumber.toString()}")),
                  initialSettings: controller.settings,
                  onWebViewCreated: (cx) {
                    controller.webViewController = cx;

                    cx.addJavaScriptHandler(
                      handlerName: "getVersion",
                      callback: (args) async {
                        debugPrint("getVersion");
                        controller.getVersion();
                      },
                    );
                  },
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.GRANT);
                  },
                  onConsoleMessage: (cx, consoleMessage) {
                    if (kDebugMode) {
                      print(consoleMessage);
                    }
                  },
                  shouldOverrideUrlLoading: (cx, navigationAction) async {
                    const platform =
                        MethodChannel("com.maklife.mak_diary/play");

                    const platform1 =
                        MethodChannel("com.maklife.mak_diary/upi");

                    // "com.maklife.mak_diary/intent"

                    const platform2 =
                        MethodChannel("com.maklife.mak_diary/intent");
                    final url = navigationAction.request.url;

                    if (url.toString().startsWith("http") ||
                        url.toString().startsWith("https")) {
                      return NavigationActionPolicy.ALLOW;
                    }

                    var uri = navigationAction.request.url;
                    debugPrint("uri:$uri");

                    if (uri != null && uri.scheme == "store") {
                      var storeUrl = Platform.isIOS
                          ? "https://apps.apple.com/in/app/maklife-dairy-fresh/id6740133568"
                          : "https://play.google.com/store/apps/details?id=com.genmak.mak_life_dairy_fresh&hl=en_IN";

                      try {
                        if (Platform.isAndroid) {
                          final bool handled = await platform
                              .invokeMethod("handlePlayUrl", {"url": storeUrl});
                          if (handled) {
                            return NavigationActionPolicy.CANCEL;
                          }
                        } else if (Platform.isIOS) {
                          if (await canLaunchUrl(
                              Uri.parse(storeUrl.toString()))) {
                            await launchUrl(Uri.parse(storeUrl.toString()),
                                mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch ';
                          }
                        }
                      } on PlatformException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Error handling UPI URL: ${e.message}")),
                        );
                      }
                    }
                    var url1 = navigationAction.request.url.toString();
                    if (url1.startsWith("upi://pay")) {
                      try {
                        if (Platform.isAndroid) {
                          final bool handled = await platform1
                              .invokeMethod("handleUPIUrl", {"url": url1});
                          if (handled) {
                            return NavigationActionPolicy.CANCEL;
                          }
                        } else if (Platform.isIOS) {
                          if (await canLaunchUrl(Uri.parse(url1.toString()))) {
                            await launchUrl(Uri.parse(url1.toString()),
                                mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch ';
                          }
                        }
                      } on PlatformException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Error handling UPI URL: ${e.message}")),
                        );
                      }
                    }
                    if (url1.startsWith("intent")) {
                      try {
                        if (Platform.isAndroid) {
                          final bool handled = await platform2
                              .invokeMethod("handleUPIUrl", {"url": url1});
                          if (handled) {
                            return NavigationActionPolicy.CANCEL;
                          }
                        } else if (Platform.isIOS) {
                          if (await canLaunchUrl(Uri.parse(url1.toString()))) {
                            await launchUrl(Uri.parse(url1.toString()),
                                mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch ';
                          }
                        }
                      } on PlatformException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Error handling UPI URL: ${e.message}")),
                        );
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onDownloadStartRequest: (cx, request) async {
                    ScaffoldMessenger.of(Get.context!)
                        .showSnackBar(const SnackBar(
                      content: Text("Downloading is in progress please wait!"),
                    ));
                    String filepath = await controller.downloadAndOpenPdf(
                      request.url.toString(),
                    );

                    Get.toNamed(Routes.PDF_SHOW,
                        arguments: [request.url.toString(), filepath]);
                  },
                ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: Colors.purple[900],
          //   onPressed: null,
          //   child: Text(
          //     Constants.appVersion,
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
        ),
      ),
    );
  }
}
