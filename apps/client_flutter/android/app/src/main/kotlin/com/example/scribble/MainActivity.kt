package com.example.scribble

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Parcelable
import android.util.Patterns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val widgetChannelName = "scribble/widget"
    private val shareChannelName = "scribble/share_intent"

    private var pendingRoute: String? = null
    private var pendingShare: Map<String, Any?>? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        captureRouteFromIntent(intent)
        captureShareFromIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        captureRouteFromIntent(intent)
        captureShareFromIntent(intent)
    }

    private fun captureRouteFromIntent(intent: Intent?) {
        val route = intent?.getStringExtra(MemoWidgetProvider.EXTRA_ROUTE)
        if (!route.isNullOrBlank()) pendingRoute = route
    }

    private fun captureShareFromIntent(intent: Intent?) {
        if (intent == null) return

        val action = intent.action ?: return
        val type = intent.type

        if (action != Intent.ACTION_SEND && action != Intent.ACTION_SEND_MULTIPLE) {
            return
        }

        val text = intent.getStringExtra(Intent.EXTRA_TEXT)?.trim().orEmpty()
        val subject = intent.getStringExtra(Intent.EXTRA_SUBJECT)?.trim().orEmpty()
        val combinedText = listOf(subject, text)
            .filter { it.isNotBlank() }
            .joinToString("\n")
            .trim()
            .ifBlank { null }

        val fileUris = mutableListOf<String>()

        if (action == Intent.ACTION_SEND) {
            val stream = intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM)
            if (stream is Uri) {
                fileUris.add(stream.toString())
            }
        } else {
            val streams = intent.getParcelableArrayListExtra<Parcelable>(Intent.EXTRA_STREAM)
            streams?.forEach { p ->
                if (p is Uri) fileUris.add(p.toString())
            }
        }

        val url = extractFirstUrl(combinedText)

        val shareType = resolveShareType(
            action = action,
            mimeType = type,
            hasText = !combinedText.isNullOrBlank(),
            hasUrl = !url.isNullOrBlank(),
            hasFiles = fileUris.isNotEmpty(),
        )

        pendingShare = mapOf(
            "type" to shareType,
            "text" to combinedText,
            "url" to url,
            "fileUris" to fileUris,
            "mimeType" to type,
            "sourceApp" to intent.`package`,
        )
    }

    private fun extractFirstUrl(text: String?): String? {
        if (text.isNullOrBlank()) return null
        val matcher = Patterns.WEB_URL.matcher(text)
        if (!matcher.find()) return null
        return matcher.group()
    }

    private fun resolveShareType(
        action: String,
        mimeType: String?,
        hasText: Boolean,
        hasUrl: Boolean,
        hasFiles: Boolean,
    ): String {
        if ((hasText && hasFiles) || (hasUrl && hasFiles) || (hasText && hasUrl)) return "mixed"
        if (hasUrl) return "url"
        if (hasText) return "text"
        if (hasFiles) {
            if (!mimeType.isNullOrBlank() && mimeType.startsWith("image/")) return "image"
            return "file"
        }

        return if (action == Intent.ACTION_SEND_MULTIPLE) "file" else "text"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, widgetChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateMemos" -> {
                        val memosJson = call.argument<String>("memosJson") ?: "[]"
                        val prefs =
                            getSharedPreferences(MemoWidgetProvider.PREFS_NAME, Context.MODE_PRIVATE)
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
                        val prefs =
                            getSharedPreferences(MemoWidgetProvider.PREFS_NAME, Context.MODE_PRIVATE)
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, shareChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "consumePendingShare" -> {
                        val payload = pendingShare
                        pendingShare = null
                        result.success(payload)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
