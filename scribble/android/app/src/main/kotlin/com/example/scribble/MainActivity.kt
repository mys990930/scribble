package com.example.scribble

import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "scribble/widget"
    private var pendingRoute: String? = null

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        captureRouteFromIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        captureRouteFromIntent(intent)
    }

    private fun captureRouteFromIntent(intent: Intent?) {
        val route = intent?.getStringExtra(MemoWidgetProvider.EXTRA_ROUTE)
        if (!route.isNullOrBlank()) pendingRoute = route
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateMemos" -> {
                    val memosJson = call.argument<String>("memosJson") ?: "[]"
                    val prefs = getSharedPreferences(MemoWidgetProvider.PREFS_NAME, Context.MODE_PRIVATE)
                    prefs.edit().putString(MemoWidgetProvider.KEY_MEMOS_JSON, memosJson).apply()

                    val intent1 = Intent(this, MemoWidgetProvider::class.java).apply {
                        action = MemoWidgetProvider.ACTION_REFRESH_MEMO_WIDGET
                    }
                    sendBroadcast(intent1)

                    val intent2 = Intent(this, MemoWidgetPaddedProvider::class.java).apply {
                        action = MemoWidgetProvider.ACTION_REFRESH_MEMO_WIDGET
                    }
                    sendBroadcast(intent2)

                    result.success(true)
                }

                "consumePendingMemo" -> {
                    val prefs = getSharedPreferences(MemoWidgetProvider.PREFS_NAME, Context.MODE_PRIVATE)
                    val pending = prefs.getString(MemoQuickAddActivity.KEY_PENDING_MEMO, null)
                    prefs.edit().remove(MemoQuickAddActivity.KEY_PENDING_MEMO).apply()
                    result.success(pending)
                }

                "consumeLaunchRoute" -> {
                    val r = pendingRoute
                    pendingRoute = null
                    result.success(r)
                }

                else -> result.notImplemented()
            }
        }
    }
}
