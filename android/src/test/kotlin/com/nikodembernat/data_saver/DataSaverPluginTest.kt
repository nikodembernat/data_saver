package com.nikodembernat.data_saver

import android.content.Context
import android.net.ConnectivityManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

/*
 * This demonstrates a simple unit test of the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

internal class DataSaverPluginTest {
    @Test
    fun onMethodCall_checkMode_returnsEnabled() {
        assertCheckMode(
            restrictBackgroundStatus = ConnectivityManager.RESTRICT_BACKGROUND_STATUS_ENABLED,
            expected = "ENABLED"
        )
    }

    @Test
    fun onMethodCall_checkMode_returnsWhitelisted() {
        assertCheckMode(
            restrictBackgroundStatus = ConnectivityManager.RESTRICT_BACKGROUND_STATUS_WHITELISTED,
            expected = "WHITELISTED"
        )
    }

    @Test
    fun onMethodCall_checkMode_returnsDisabled() {
        assertCheckMode(
            restrictBackgroundStatus = ConnectivityManager.RESTRICT_BACKGROUND_STATUS_DISABLED,
            expected = "DISABLED"
        )
    }

    @Test
    fun onMethodCall_checkMode_fallsBackToDisabledOnUnknownStatus() {
        assertCheckMode(restrictBackgroundStatus = Int.MAX_VALUE, expected = "DISABLED")
    }

    @Test
    fun onMethodCall_unknownMethod_isNotImplemented() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)

        attachedPlugin(ConnectivityManager.RESTRICT_BACKGROUND_STATUS_DISABLED)
            .onMethodCall(MethodCall("getPlatformVersion", null), mockResult)

        Mockito.verify(mockResult).notImplemented()
    }

    private fun assertCheckMode(
        restrictBackgroundStatus: Int,
        expected: String
    ) {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)

        attachedPlugin(restrictBackgroundStatus)
            .onMethodCall(MethodCall("checkMode", null), mockResult)

        Mockito.verify(mockResult).success(expected)
    }

    private fun attachedPlugin(restrictBackgroundStatus: Int): DataSaverPlugin {
        val connectivityManager = Mockito.mock(ConnectivityManager::class.java)
        Mockito
            .`when`(connectivityManager.restrictBackgroundStatus)
            .thenReturn(restrictBackgroundStatus)

        val context = Mockito.mock(Context::class.java)
        Mockito
            .`when`(context.getSystemService(ConnectivityManager::class.java))
            .thenReturn(connectivityManager)

        val binding = Mockito.mock(FlutterPlugin.FlutterPluginBinding::class.java)
        Mockito.`when`(binding.applicationContext).thenReturn(context)
        Mockito.`when`(binding.binaryMessenger).thenReturn(Mockito.mock(BinaryMessenger::class.java))

        return DataSaverPlugin().apply { onAttachedToEngine(binding) }
    }
}
