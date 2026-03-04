package com.example.scribble

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.SystemClock
import android.text.SpannableString
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.style.ForegroundColorSpan
import android.widget.RemoteViews

class MemoWidgetProvider : AppWidgetProvider() {
    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        schedulePeriodicRefresh(context)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        cancelPeriodicRefresh(context)
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        appWidgetIds.forEach { appWidgetId ->
            val views = buildViews(context)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH_MEMO_WIDGET) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, MemoWidgetProvider::class.java))
            onUpdate(context, manager, ids)
        }
    }

    private fun schedulePeriodicRefresh(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.setInexactRepeating(
            AlarmManager.ELAPSED_REALTIME_WAKEUP,
            SystemClock.elapsedRealtime() + REFRESH_INTERVAL_MS,
            REFRESH_INTERVAL_MS,
            refreshPendingIntent(context)
        )
    }

    private fun cancelPeriodicRefresh(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(refreshPendingIntent(context))
    }

    private fun refreshPendingIntent(context: Context): PendingIntent {
        val refreshIntent = Intent(context, MemoWidgetProvider::class.java).apply {
            action = ACTION_REFRESH_MEMO_WIDGET
        }
        return PendingIntent.getBroadcast(
            context,
            2002,
            refreshIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun buildViews(context: Context): RemoteViews {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val memosJson = prefs.getString(KEY_MEMOS_JSON, "[]") ?: "[]"

        val views = RemoteViews(context.packageName, R.layout.memo_widget)
        views.setTextViewText(R.id.memo_widget_list, memosJsonToStyledText(memosJson))
        views.setOnClickPendingIntent(R.id.memo_widget_refresh_button, refreshPendingIntent(context))

        val openNotesIntent = Intent(context, MainActivity::class.java).apply {
            action = ACTION_OPEN_NOTES
            putExtra(EXTRA_ROUTE, "/memo")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val openPendingIntent = PendingIntent.getActivity(
            context,
            2003,
            openNotesIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.memo_widget_root, openPendingIntent)

        return views
    }

    private fun memosJsonToStyledText(json: String): CharSequence {
        return try {
            val contents = Regex("\\\"content\\\"\\s*:\\s*\\\"(.*?)\\\"")
                .findAll(json)
                .map { truncateForSingleLine(it.groupValues[1]) }
                .toList()
            val dueAtEpochMs = Regex("\\\"dueAtEpochMs\\\"\\s*:\\s*(null|-?\\d+)")
                .findAll(json)
                .map {
                    val raw = it.groupValues[1]
                    if (raw == "null") null else raw.toLongOrNull()
                }
                .toList()

            if (contents.isEmpty()) return "No memos"

            val b = SpannableStringBuilder()
            contents.take(3).forEachIndexed { i, c ->
                val due = dueText(dueAtEpochMs.getOrNull(i))
                val line = "- $c ($due)"
                val span = SpannableString(line)
                if (due.startsWith("overdue")) {
                    val start = line.indexOf(due)
                    if (start >= 0) {
                        span.setSpan(
                            ForegroundColorSpan(Color.parseColor("#E6535E")),
                            start,
                            start + due.length,
                            Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                        )
                    }
                }
                b.append(span)
                if (i < 2) b.append("\n")
            }
            b
        } catch (_: Exception) {
            "No memos"
        }
    }

    private fun dueText(epochMs: Long?): String {
        if (epochMs == null) return "no due"
        val diffMs = epochMs - System.currentTimeMillis()
        val absMin = kotlin.math.abs(diffMs) / 60000
        val h = absMin / 60
        val m = absMin % 60
        val s = if (h > 0) "${h}h ${m}m" else "${absMin}m"
        return if (diffMs < 0) "overdue $s" else "due in $s"
    }

    private fun truncateForSingleLine(text: String, maxChars: Int = 26): String {
        val normalized = text.replace("\n", " ").trim()
        if (normalized.length <= maxChars) return normalized
        return normalized.take(maxChars).trimEnd() + "(...)"
    }


    companion object {
        const val ACTION_REFRESH_MEMO_WIDGET = "com.example.scribble.ACTION_REFRESH_MEMO_WIDGET"
        const val ACTION_OPEN_NOTES = "com.example.scribble.ACTION_OPEN_NOTES"
        const val PREFS_NAME = "memo_widget_prefs"
        const val KEY_MEMOS_JSON = "memos_json"
        const val EXTRA_ROUTE = "route"
        private const val REFRESH_INTERVAL_MS = 5 * 60 * 1000L
    }
}
