import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/animated_button.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: settings.isDarkMode,
                  onChanged: (_) => settings.toggleDarkMode(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.vibration),
                title: const Text('Haptic Feedback'),
                trailing: Switch(
                  value: settings.useHapticFeedback,
                  onChanged: (_) => settings.toggleHapticFeedback(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.format_quote),
                title: const Text('Motivational Quotes'),
                trailing: Switch(
                  value: settings.showMotivationalQuotes,
                  onChanged: (_) => settings.toggleMotivationalQuotes(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Units',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Distance Unit'),
                    trailing: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'km', label: Text('KM')),
                        ButtonSegment(value: 'mi', label: Text('MI')),
                      ],
                      selected: {settings.distanceUnit},
                      onSelectionChanged: (Set<String> selection) {
                        settings.setDistanceUnit(selection.first);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Weight Unit'),
                    trailing: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'kg', label: Text('KG')),
                        ButtonSegment(value: 'lb', label: Text('LB')),
                      ],
                      selected: {settings.weightUnit},
                      onSelectionChanged: (Set<String> selection) {
                        settings.setWeightUnit(selection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}