package com.maklife.mak_diary

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
     private val CHANNEL = "com.maklife.mak_diary/play"
     private val CHANNEL1 = "com.maklife.mak_diary/upi"
     private val CHANNEL2 = "com.maklife.mak_diary/intent"
     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL1).setMethodCallHandler { call, result ->
            if (call.method == "handleUPIUrl") {
                val url = call.argument<String>("url")
                if (url != null && url.startsWith("upi")) {
                    handleUPIUrl(url)
                    result.success(true)
                } else {
                    result.error("INVALID_URL", "The URL is not valid", null)
                }
            } else {
                result.notImplemented()
            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2).setMethodCallHandler { call, result ->
            if (call.method == "handleUPIUrl") {
                val url = call.argument<String>("url")
                if (url != null && url.startsWith("intent")) {
                    handleIntentUrl(url)
                    result.success(true)
                } else {
                    result.error("INVALID_URL", "The URL is not valid", null)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "handlePlayUrl") {
                val url = call.argument<String>("url")
                if (url != null ) {
                    handlePlayUrl(url)
                    result.success(true)
                } else {
                    result.error("INVALID_URL", "The URL is not valid", null)
                }
            } else {
                result.notImplemented()
            }
        }
     }

      private fun handleUPIUrl(url: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(url)
        startActivity(intent)
    }

      private fun handlePlayUrl(url: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(url)
        startActivity(intent)
    }

    private fun handleIntentUrl(url: String) {
    try {
        val intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
        if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
        } else {
            val fallbackUrl = intent.getStringExtra("browser_fallback_url")
            if (fallbackUrl != null) {
                val fallbackIntent = Intent(Intent.ACTION_VIEW, Uri.parse(fallbackUrl))
                startActivity(fallbackIntent)
            }
        }
    } catch (e: Exception) {
        e.printStackTrace()
    }
}
}


