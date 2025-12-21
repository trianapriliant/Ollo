package com.ollo.ollo

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import android.app.PendingIntent
import android.content.Intent
import android.view.View

class OlloBudgetWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout_budget).apply {
                
                // 1. Get Data from SharedPreferences
                val spentTxt = widgetData.getString("budget_spent_text", "Rp 0") ?: "Rp 0"
                val totalTxt = widgetData.getString("budget_total_text", "/ Rp 0") ?: "/ Rp 0"
                val percentTxt = widgetData.getString("budget_percent_text", "0%") ?: "0%"
                val remainingTxt = widgetData.getString("budget_remaining_text", "Remaining: Rp 0") ?: "Remaining: Rp 0"
                val progressVal = widgetData.getInt("budget_progress", 0)

                // 2. Update Views
                setTextViewText(R.id.widget_budget_spent, spentTxt)
                setTextViewText(R.id.widget_budget_total, totalTxt)
                setTextViewText(R.id.widget_budget_percent, percentTxt)
                setTextViewText(R.id.widget_budget_remaining, remainingTxt)
                setProgressBar(R.id.widget_budget_progress, 100, progressVal, false)

                // 3. Handle Click -> Open Budget Screen
                val intent = Intent(context, MainActivity::class.java).apply {
                    action = "es.antonborri.home_widget.action.LAUNCH"
                    data = android.net.Uri.parse("ollo://app/budget") 
                }
                
                val pendingIntent = PendingIntent.getActivity(
                    context, 
                    0, 
                    intent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                setOnClickPendingIntent(R.id.widget_budget_root, pendingIntent)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
