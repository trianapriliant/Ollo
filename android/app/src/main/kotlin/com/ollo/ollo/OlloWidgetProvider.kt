package com.ollo.ollo

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import android.app.PendingIntent
import android.content.Intent

class OlloWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                
                // 1. Get Data from SharedPreferences (keys must match Flutter side)
                val income = widgetData.getString("income_amount", "Rp 0") ?: "Rp 0"
                val expense = widgetData.getString("expense_amount", "Rp 0") ?: "Rp 0"
                val balance = widgetData.getString("balance_amount", "Rp 0") ?: "Rp 0"
                val month = widgetData.getString("current_month", "This Month") ?: "This Month"

                // 2. Update TextViews
                setTextViewText(R.id.widget_income_amount, income)
                setTextViewText(R.id.widget_expense_amount, expense)
                setTextViewText(R.id.widget_balance_amount, balance)
                setTextViewText(R.id.widget_month_text, month)

                // 3. Handle "Add Transaction" Button Click
                // Launches MainActivity with a special URI or Extra to route to Add Screen
                // For simplicity, we just launch the app. In Flutter, we can check for logic.
                // Or better, launch with a URI: "ollo://add-transaction"
                val intent = Intent(context, MainActivity::class.java).apply {
                    action = "es.antonborri.home_widget.action.LAUNCH"
                    data = android.net.Uri.parse("ollo://add-transaction") 
                }
                
                // PendingIntent.FLAG_IMMUTABLE is required for Android 12+
                val pendingIntent = PendingIntent.getActivity(
                    context, 
                    0, 
                    intent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                setOnClickPendingIntent(R.id.widget_add_button, pendingIntent)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
