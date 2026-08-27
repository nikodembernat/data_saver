package com.nikodembernat.data_saver

import android.content.Context
import android.net.ConnectivityManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DataSaverPlugin */
class DataSaverPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that handles the communication between Flutter and native Android.
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity.
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "data_saver")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "checkMode" -> result.success(checkMode())
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * Reads the current Data Saver policy.
     *
     * Anything other than the two restricting states is reported as `DISABLED`,
     * so the Dart side always gets a reply.
     */
    private fun checkMode(): String {
        val connectivityManager =
            context.getSystemService(ConnectivityManager::class.java) ?: return "DISABLED"

        return when (connectivityManager.restrictBackgroundStatus) {
            ConnectivityManager.RESTRICT_BACKGROUND_STATUS_ENABLED -> "ENABLED"
            ConnectivityManager.RESTRICT_BACKGROUND_STATUS_WHITELISTED -> "WHITELISTED"
            else -> "DISABLED"
        }
    }
}
