package com.example.native_code

import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val mc = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, "course.flutter.dev/battery")
        mc.setMethodCallHandler { call, result ->
            run {
                if (call.method.equals("getBatteryLevel")) {
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Could not fetch battery level", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    private val batteryLevel: Int
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = Intent(
                applicationContext.registerReceiver(
                    null, IntentFilter(
                        Intent.ACTION_BATTERY_CHANGED
                    )
                )
            )
            (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) / intent.getIntExtra(
                BatteryManager.EXTRA_SCALE,
                -1
            )
        }

}
