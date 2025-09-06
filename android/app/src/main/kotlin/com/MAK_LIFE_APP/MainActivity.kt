package com.MAK_LIFE_APP

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.MAK_LIFE_APP/play"
    private val CHANNEL1 = "com.MAK_LIFE_APP/upi"
    private val CHANNEL2 = "com.MAK_LIFE_APP/intent"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // UPI channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL1).setMethodCallHandler { call, result ->
            if (call.method == "handleUPIUrl") {
                val url = call.argument<String>("url")
                if (url != null && url.startsWith("upi://pay")) {
                    try {
                        val handled = handleUPIUrl(url)
                        if (handled) {
                            result.success(true)
                        } else {
                            result.error("NO_UPI_APP", "No UPI app found to handle intent", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.localizedMessage, null)
                    }
                } else {
                    result.error("INVALID_URL", "The URL is not valid", null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Intent channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2).setMethodCallHandler { call, result ->
            if (call.method == "handleUPIUrl") {  // for intent:// links
                val url = call.argument<String>("url")
                if (url != null && url.startsWith("intent")) {
                    try {
                        val handled = handleIntentUrl(url)
                        if (handled) {
                            result.success(true)
                        } else {
                            result.error("NO_APP", "No app found to handle intent", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.localizedMessage, null)
                    }
                } else {
                    result.error("INVALID_URL", "The URL is not valid", null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Play Store / generic URL channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "handlePlayUrl") {
                val url = call.argument<String>("url")
                if (url != null) {
                    try {
                        val handled = handlePlayUrl(url)
                        if (handled) {
                            result.success(true)
                        } else {
                            result.error("NO_BROWSER", "No browser found to open URL", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.localizedMessage, null)
                    }
                } else {
                    result.error("INVALID_URL", "The URL is not valid", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // --- Handlers ---

    private fun handleUPIUrl(url: String): Boolean {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        return if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
            true
        } else {
            false
        }
    }

    private fun handlePlayUrl(url: String): Boolean {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        return if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
            true
        } else {
            false
        }
    }

    private fun handleIntentUrl(url: String): Boolean {
        return try {
            val intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
            if (intent.resolveActivity(packageManager) != null) {
                startActivity(intent)
                true
            } else {
                val fallbackUrl = intent.getStringExtra("browser_fallback_url")
                if (fallbackUrl != null) {
                    val fallbackIntent = Intent(Intent.ACTION_VIEW, Uri.parse(fallbackUrl))
                    if (fallbackIntent.resolveActivity(packageManager) != null) {
                        startActivity(fallbackIntent)
                        true
                    } else {
                        false
                    }
                } else {
                    false
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
