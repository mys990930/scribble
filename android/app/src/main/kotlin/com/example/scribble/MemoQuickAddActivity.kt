package com.example.scribble

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.RadioGroup
import org.json.JSONObject

class MemoQuickAddActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.memo_quick_add_activity)

        val input = findViewById<EditText>(R.id.memo_quick_add_input)
        val dueGroup = findViewById<RadioGroup>(R.id.memo_quick_due_group)
        val cancel = findViewById<Button>(R.id.memo_quick_add_cancel)
        val add = findViewById<Button>(R.id.memo_quick_add_submit)

        cancel.setOnClickListener { finish() }
        add.setOnClickListener {
            val text = input.text?.toString()?.trim().orEmpty()
            if (text.isNotEmpty()) {
                val dueMinutes = when (dueGroup.checkedRadioButtonId) {
                    R.id.due_1h -> 60
                    R.id.due_6h -> 360
                    R.id.due_12h -> 720
                    R.id.due_1d -> 1440
                    else -> 0
                }

                val payload = JSONObject().apply {
                    put("text", text)
                    put("dueMinutes", if (dueMinutes > 0) dueMinutes else JSONObject.NULL)
                }.toString()

                val prefs = getSharedPreferences(MemoWidgetProvider.PREFS_NAME, Context.MODE_PRIVATE)
                prefs.edit().putString(KEY_PENDING_MEMO, payload).apply()

                val refresh = Intent(MemoWidgetProvider.ACTION_REFRESH_MEMO_WIDGET)
                sendBroadcast(refresh)
            }
            val launchIntent = Intent(this, MainActivity::class.java)
            launchIntent.putExtra(MemoWidgetProvider.EXTRA_ROUTE, "/note")
            launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            startActivity(launchIntent)
            finish()
        }
    }

    companion object {
        const val KEY_PENDING_MEMO = "pending_memo"
    }
}
