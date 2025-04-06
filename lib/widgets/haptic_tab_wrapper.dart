import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class HapticTabWrapper extends StatelessWidget {
  final Widget child;

  const HapticTabWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return GestureDetector(
          onTapDown: (_) {
            if (settings.useHapticFeedback) {
              HapticFeedback.selectionClick();
            }
          },
          behavior: HitTestBehavior.translucent,
          child: child,
        );
      },
    );
  }
}