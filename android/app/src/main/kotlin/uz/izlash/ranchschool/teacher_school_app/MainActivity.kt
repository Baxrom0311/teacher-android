package uz.izlash.ranchschool.teacher_school_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val manager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channel =
            NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = CHANNEL_DESCRIPTION
                enableLights(true)
                enableVibration(true)
            }

        manager.createNotificationChannel(channel)
    }

    companion object {
        private const val CHANNEL_ID = "eschool_notifications"
        private const val CHANNEL_NAME = "eSchool Notifications"
        private const val CHANNEL_DESCRIPTION =
            "Teacher app push notifications"
    }
}
