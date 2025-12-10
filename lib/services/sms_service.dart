import 'package:another_telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;

  Future<bool> requestSmsPermission() async {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      status = await Permission.sms.request();
    }
    return status.isGranted;
  }

  static const platform = MethodChannel('com.impostersms.messages');

  /// Request all necessary permissions at app startup
  Future<bool> requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.sms,
      Permission.phone,
      Permission.contacts, // If contacts are accessed
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    // Also request native Telephony permissions if needed (though Permission handler usually covers it)
    if (allGranted) {
      await telephony.requestPhoneAndSmsPermissions;
    }

    return allGranted;
  }

  /// Send individual SMS to a single recipient using Native Android Manager
  Future<String> sendIndividualSms({
    required String recipient,
    required String message,
    bool isRetry = false, // Add retry flag
  }) async {
    try {
      // Clean phone number first
      String formattedRecipient = isRetry
          ? _formatPhoneNumber(recipient)
          : recipient;

      print('Sending SMS via Native Channel to $formattedRecipient');

      final String result = await platform.invokeMethod(
        'sendSMS',
        <String, dynamic>{'recipient': formattedRecipient, 'message': message},
      );

      print('Native SMS Result: $result');
      return 'SMS sent to $formattedRecipient';
    } catch (e) {
      print(
        'Error sending SMS to $recipient via Native Channel: ${e.toString()}',
      );
      return 'Error: ${e.toString()}';
    }
  }

  /// Send SMS to multiple recipients (sends individually to each)
  Future<Map<String, String>> sendSmsToMultiple({
    required Map<String, String> recipientMessages,
    Function(String recipient, String status)? onProgress,
  }) async {
    Map<String, String> results = {};

    try {
      // Check permissions via standard Permission handler first
      print('Checking SMS permissions...');
      var smsStatus = await Permission.sms.status;
      if (!smsStatus.isGranted) {
        smsStatus = await Permission.sms.request();
        if (!smsStatus.isGranted) {
          for (var recipient in recipientMessages.keys) {
            results[recipient] = 'Permissions denied';
            onProgress?.call(recipient, 'Failed: Permissions denied');
          }
          return results;
        }
      }

      print(
        'Starting to send ${recipientMessages.length} native SMS messages...',
      );
      int count = 0;

      for (var entry in recipientMessages.entries) {
        String recipient = entry.key;
        String message = entry.value;
        count++;

        try {
          print(
            '[$count/${recipientMessages.length}] Sending to $recipient...',
          );
          onProgress?.call(recipient, 'Sending...');

          await sendIndividualSms(recipient: recipient, message: message);
          results[recipient] = 'Success';
          onProgress?.call(recipient, 'Sent');

          // Small delay between messages
          await Future.delayed(const Duration(milliseconds: 1000));
        } catch (e) {
          print(
            '[$count/${recipientMessages.length}] Failed for $recipient: ${e.toString()}',
          );

          // Retry with formatting
          try {
            print(
              '[$count/${recipientMessages.length}] Retrying with formatted number...',
            );
            onProgress?.call(recipient, 'Retrying...');

            await sendIndividualSms(
              recipient: recipient,
              message: message,
              isRetry: true,
            );
            results[recipient] = 'Success (after retry)';
            onProgress?.call(recipient, 'Sent');
          } catch (e2) {
            final errorMsg = 'Failed: ${e2.toString()}';
            results[recipient] = errorMsg;
            onProgress?.call(recipient, 'Failed');
          }
        }
      }

      return results;
    } catch (e) {
      print('FATAL ERROR: ${e.toString()}');
      for (var recipient in recipientMessages.keys) {
        results[recipient] = 'Fatal error: ${e.toString()}';
        onProgress?.call(recipient, 'Failed');
      }
      return results;
    }
  }

  // Helper to format phone numbers for Ethiopia
  String _formatPhoneNumber(String phone) {
    // Remove any spaces or dashes
    String cleaned = phone.replaceAll(RegExp(r'\s+|-'), '');

    // Check if it starts with 09 (standard Ethiopian mobile prefix)
    if (cleaned.startsWith('09') && cleaned.length == 10) {
      return '+251${cleaned.substring(1)}';
    }

    // Check if it starts with 251 but no plus
    if (cleaned.startsWith('251') && cleaned.length == 12) {
      return '+$cleaned';
    }

    return cleaned;
  }

  /// Legacy method for backward compatibility
  Future<String> sendSms({
    required String message,
    required List<String> recipients,
  }) async {
    try {
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

      if (permissionsGranted != true) {
        return 'SMS permissions not granted';
      }

      int successCount = 0;
      int failCount = 0;

      for (String recipient in recipients) {
        try {
          await telephony.sendSms(to: recipient, message: message);
          successCount++;
          // Small delay between messages
          await Future.delayed(const Duration(milliseconds: 500));
        } catch (e) {
          print('Error sending SMS to $recipient: ${e.toString()}');
          failCount++;
        }
      }

      if (failCount == 0) {
        return 'SMS sent successfully to $successCount recipient(s)';
      } else {
        return 'SMS sent to $successCount recipient(s), failed for $failCount';
      }
    } catch (e) {
      return 'Error sending SMS: ${e.toString()}';
    }
  }
}
