package com.ollo.ollo

import android.content.Intent
import android.service.quicksettings.TileService
import android.app.PendingIntent
import android.os.Build
import android.service.quicksettings.Tile

class OlloQuickSettingsTileService : TileService() {

    override fun onClick() {
        super.onClick()
        
        val intent = Intent(this, MainActivity::class.java).apply {
            action = "es.antonborri.home_widget.action.LAUNCH" // Consistent with widget action
            data = android.net.Uri.parse("ollo://app/quick-record")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }

        // Collapse the status bar/quick settings panel before launching
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
             val pendingIntent = PendingIntent.getActivity(
                this,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
            startActivityAndCollapse(pendingIntent)
        } else {
            startActivityAndCollapse(intent)
        }
    }

    override fun onStartListening() {
        super.onStartListening()
        // Update tile state
        val tile = qsTile
        tile.state = Tile.STATE_ACTIVE
        tile.label = "Quick Record"
        // tile.icon is set in Manifest usually, or here
        // tile.icon = Icon.createWithResource(this, R.drawable.ic_mic_white_24dp) 
        tile.updateTile()
    }
}
