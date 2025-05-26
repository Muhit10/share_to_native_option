import 'package:flutter/material.dart';
import '../widgets/share_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _shareButtonKey = GlobalKey();
  bool _isSharing = false;

  /// Handles the share button tap
  Future<void> _handleShareTap() async {
    if (_isSharing) return; // Prevent multiple taps

    setState(() {
      _isSharing = true;
    });

    try {
      // Get button position for iPad compatibility
      final Rect? sharePosition = ShareUtil.getSharePositionOrigin(
        context,
        _shareButtonKey,
      );

      // Call the share utility
      await ShareUtil.shareApp(sharePositionOrigin: sharePosition);

      // Show success feedback
      if (mounted) {
        _showShareFeedback(success: true);
      }
    } catch (e) {
      // Show error feedback
      if (mounted) {
        _showShareFeedback(success: false, error: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  /// Shows feedback after share attempt
  void _showShareFeedback({required bool success, String? error}) {
    final SnackBar snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            success ? Icons.check_circle : Icons.error,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              success
                  ? 'Share dialog opened successfully!'
                  : 'Failed to share: ${error ?? 'Unknown error'}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: success ? Colors.green : Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Share Demo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App icon/logo placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.mobile_friendly_rounded,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 32),

              // App title
              Text(
                'Share Demo App',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // App description
              Text(
                'Tap the button below to share this app with your friends and family!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Share button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  key: _shareButtonKey,
                  onPressed: _isSharing ? null : _handleShareTap,
                  icon: _isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.share_rounded, size: 24),
                  label: Text(
                    _isSharing ? 'Sharing...' : 'Share App',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    elevation: 2,
                    shadowColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Additional share options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSecondaryShareButton(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    onTap: () async {
                      try {
                        await ShareUtil.shareAppViaEmail();
                        if (mounted) {
                          _showShareFeedback(success: true);
                        }
                      } catch (e) {
                        if (mounted) {
                          _showShareFeedback(
                            success: false,
                            error: e.toString(),
                          );
                        }
                      }
                    },
                  ),
                  _buildSecondaryShareButton(
                    icon: Icons.share_outlined,
                    label: 'Platform',
                    onTap: () async {
                      try {
                        final Rect? sharePosition =
                            ShareUtil.getSharePositionOrigin(
                          context,
                          _shareButtonKey,
                        );
                        await ShareUtil.shareAppPlatformSpecific(
                          sharePositionOrigin: sharePosition,
                        );
                        if (mounted) {
                          _showShareFeedback(success: true);
                        }
                      } catch (e) {
                        if (mounted) {
                          _showShareFeedback(
                            success: false,
                            error: e.toString(),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds secondary share buttons
  Widget _buildSecondaryShareButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
