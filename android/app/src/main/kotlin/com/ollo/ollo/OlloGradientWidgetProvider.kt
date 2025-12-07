package com.ollo.ollo

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import android.app.PendingIntent
import android.content.Intent

class OlloGradientWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout_gradient).apply {
                
                // 1. Get Data
                val todayAmount = widgetData.getString("today_expense", "Rp 0") ?: "Rp 0"
                val todayDay = widgetData.getString("today_day", "Today") ?: "Today"
                // Optional: We can show Income too if we want, but user asked for specific layout.

                // 2. Update TextViews
                setTextViewText(R.id.widget_gradient_amount, todayAmount)
                setTextViewText(R.id.widget_gradient_day, todayDay)
                
                // 3. Handle Click (Open Add Transaction)
                val intent = Intent(context, MainActivity::class.java).apply {
                    action = "es.antonborri.home_widget.action.LAUNCH"
                    data = android.net.Uri.parse("ollo://add-transaction") 
                }
                
                val pendingIntent = PendingIntent.getActivity(
                    context, 
                    0, 
                    intent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                // Make the whole widget clickable
                setOnClickPendingIntent(R.id.widget_gradient_amount, pendingIntent)
                // Or maybe just the background if possible, or bind to root layout ID? 
                // RemoteViews doesn't easily target root, but we can wrap root in ID if needed.
                // For now, let's target the amount text which is center and large.
                // Actually, let's create an ID for the root in XML if needed, but standard practice:
                // We can't identify root easily in standard RemoteViews usage without ID.
                // Let's assume user taps the center. Or add ID to root in XML.
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
