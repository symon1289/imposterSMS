package com.impostersms.impostersms

import android.os.Build
import android.telephony.SmsManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.impostersms.messages"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val recipient = call.argument<String>("recipient")
                val message = call.argument<String>("message")

                if (recipient != null && message != null) {
                    sendSMS(recipient, message, result)
                } else {
                    result.error("INVALID_ARGUMENTS", "Recipient or message is missing", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSMS(recipient: String, message: String, result: MethodChannel.Result) {
        try {
            val smsManager: SmsManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                // For Android 12 (API 31) and above
                applicationContext.getSystemService(SmsManager::class.java)
            } else {
                // For older versions (Deprecated in API 31)
                @Suppress("DEPRECATION")
                SmsManager.getDefault()
            }

            // Split message if it's too long
            val parts = smsManager.divideMessage(message)
            
            // Send message without explicit pending intents for now (fire and forget from Kotlin side)
            // Ideally we would use PendingIntent to track delivery status, but this is a simple fallback
            if (parts.size > 1) {
                smsManager.sendMultipartTextMessage(recipient, null, parts, null, null)
            } else {
                smsManager.sendTextMessage(recipient, null, message, null, null)
            }
            
            result.success("SMS Sent via Native Manager")
        } catch (e: Exception) {
            result.error("SEND_FAILED", "Failed to send SMS: ${e.message}", null)
        }
    }
}
