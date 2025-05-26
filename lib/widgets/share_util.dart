import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

/// Utility class for handling app sharing functionality
class ShareUtil {
  // App constants - customize these according to your app
  static const String _appName = 'Share Demo App';
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.shareappdemo';
  static const String _appStoreUrl =
      'https://apps.apple.com/app/id123456789'; // For iOS

  /// Shares the app's Play Store link with customizable message
  static Future<void> shareApp({
    String? customMessage,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final String message = customMessage ?? _getDefaultShareMessage();

      await Share.share(
        message,
        subject: 'Check out $_appName!',
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      // Log error or handle it gracefully
      debugPrint('Error sharing app: $e');
      rethrow;
    }
  }

  /// Shares app with different content for different platforms
  static Future<void> shareAppPlatformSpecific({
    Rect? sharePositionOrigin,
  }) async {
    try {
      // You can detect platform and share accordingly
      const String message = 'Hey! Check out this amazing app: $_playStoreUrl';

      await Share.share(
        message,
        subject: 'Download $_appName',
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      debugPrint('Error sharing app: $e');
      rethrow;
    }
  }

  /// Shares app via specific share method (if available)
  static Future<void> shareAppViaEmail() async {
    try {
      const String emailBody = '''
Hello!

I wanted to share this amazing app with you: $_appName

Download it from the Play Store: $_playStoreUrl

Hope you enjoy it!
      ''';

      await Share.share(emailBody, subject: 'Check out $_appName!');
    } catch (e) {
      debugPrint('Error sharing via email: $e');
      rethrow;
    }
  }

  /// Gets default share message
  static String _getDefaultShareMessage() {
    return '''
🚀 Hey! I found this awesome app: $_appName

Download it here: $_playStoreUrl

You'll love it! 😊
    ''';
  }

  /// Share with files (for future use)
  static Future<void> shareWithFiles({
    required List<String> filePaths,
    String? text,
    String? subject,
  }) async {
    try {
      final List<XFile> files = filePaths.map((path) => XFile(path)).toList();

      await Share.shareXFiles(files, text: text, subject: subject);
    } catch (e) {
      debugPrint('Error sharing files: $e');
      rethrow;
    }
  }

  /// Gets the share position for iPad (required for iPad)
  static Rect? getSharePositionOrigin(
    BuildContext context,
    GlobalKey? buttonKey,
  ) {
    if (buttonKey?.currentContext != null) {
      final RenderBox renderBox =
          buttonKey!.currentContext!.findRenderObject() as RenderBox;
      final Size size = renderBox.size;
      final Offset offset = renderBox.localToGlobal(Offset.zero);

      return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    }
    return null;
  }
}
