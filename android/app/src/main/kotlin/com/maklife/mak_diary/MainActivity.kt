package com.maklife.mak_diary

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
     private val CHANNEL = "com.maklife.mak_diary/play"
     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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

      private fun handlePlayUrl(url: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(url)
        startActivity(intent)
    }
}


