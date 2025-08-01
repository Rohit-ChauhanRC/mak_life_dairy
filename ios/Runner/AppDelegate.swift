import Flutter
import UIKit
import WebKit
import flutter_downloader

@main
@objc class AppDelegate: FlutterAppDelegate {

    var webView: WKWebView?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.genmak.maklifedairy/channel",
            binaryMessenger: controller.binaryMessenger)

        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true

        webViewConfiguration.preferences.javaScriptEnabled = true

        webView = WKWebView(frame: CGRect.zero, configuration: webViewConfiguration)

        let upiChannel = FlutterMethodChannel(
            name: "com.genmak.maklifedairy/upi",
            binaryMessenger: controller.binaryMessenger)
        upiChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "handleUPIUrl" {
                if let args = call.arguments as? [String: Any],
                    let urlString = args["url"] as? String,
                    let url = URL(string: urlString)
                {

                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        result(true)
                    } else {
                        result(
                            FlutterError(
                                code: "UNAVAILABLE",
                                message: "UPI app not installed",
                                details: nil))
                    }
                } else {
                    result(
                        FlutterError(
                            code: "INVALID_ARGUMENT",
                            message: "Invalid URL argument",
                            details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        FlutterDownloaderPlugin.setPluginRegistrantCallback { registry in
            if !registry.hasPlugin("FlutterDownloaderPlugin") {
                FlutterDownloaderPlugin.register(
                    with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func enableWebKit(result: @escaping FlutterResult) {
        // Initialize the WKWebView (WebKit WebView)
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.preferences.javaScriptEnabled = true

        webView = WKWebView(frame: CGRect.zero, configuration: webViewConfiguration)

        // Now the webView is initialized and WebKit is enabled
        result("WebKit Enabled Successfully")
    }
}
