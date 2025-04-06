import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/fitness_tracker_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/animated_button.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  final _achievementController = TextEditingController();
  final List<Map<String, String>> _achievements = [];
  final List<Map<String, String>> _scholarships = [
    {
      'title': 'Sports Excellence Scholarship',
      'description': 'For outstanding athletes with national level achievements',
      'amount': '\$5000/year',
    },
    {
      'title': 'Youth Sports Development Grant',
      'description': 'Supporting young athletes in training and equipment',
      'amount': '\$2500/year',
    },
  ];

  @override
  void dispose() {
    _achievementController.dispose();
    super.dispose();
  }

  void _addAchievement() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _achievements.add({
          'title': _achievementController.text,
          'date': DateTime.now().toString().split(' ')[0],
        });
        _achievementController.clear();
      });
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Fitness Stats'),
              Tab(text: 'Achievements'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Fitness Stats Tab
            Consumer<FitnessTrackerProvider>(
              builder: (context, tracker, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                "Today's Activity",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatCard(
                                    icon: Icons.directions_walk,
                                    value: '${tracker.steps}',
                                    label: 'Steps',
                                  ),
                                  _buildStatCard(
                                    icon: Icons.directions_run,
                                    value: '${tracker.distance.toStringAsFixed(2)} km',
                                    label: 'Distance',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatCard(
                                    icon: Icons.local_fire_department,
                                    value: '${tracker.calories}',
                                    label: 'Calories',
                                  ),
                                  _buildStatCard(
                                    icon: Icons.timer,
                                    value: '${tracker.activeMinutes} min',
                                    label: 'Active Time',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedButton(
                        label: 'Reset Daily Stats',
                        icon: Icons.refresh,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Reset Stats'),
                              content: const Text('Are you sure you want to reset today\'s stats?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    tracker.resetData();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Reset'),
                                ),
                              ],
                            ),
                          );
                        },
                        width: double.infinity,
                      ),
                    ],
                  ),
                );
              },
            ),
            // Achievements Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _achievementController,
                              decoration: const InputDecoration(
                                labelText: 'Add Achievement',
                                hintText: 'E.g., Won district championship',
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter an achievement';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            AnimatedButton(
                              label: 'Add Achievement',
                              icon: Icons.add,
                              onPressed: _addAchievement,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = _achievements[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                child: ListTile(
                                  title: Text(achievement['title'] ?? ''),
                                  subtitle: Text(achievement['date'] ?? ''),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() => _achievements.removeAt(index));
                                      HapticFeedback.mediumImpact();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Available Scholarships',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _scholarships.length,
                      itemBuilder: (context, index) {
                        final scholarship = _scholarships[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                child: ListTile(
                                  title: Text(scholarship['title'] ?? ''),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(scholarship['description'] ?? ''),
                                      Text(
                                        scholarship['amount'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.successColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Settings Tab
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Dark Mode'),
                            subtitle: const Text('Enable dark color theme'),
                            value: settings.isDarkMode,
                            onChanged: (value) {
                              settings.toggleDarkMode();
                              HapticFeedback.selectionClick();
                            },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: const Text('Haptic Feedback'),
                            subtitle: const Text('Enable vibration on interactions'),
                            value: settings.useHapticFeedback,
                            onChanged: (value) {
                              settings.toggleHapticFeedback();
                              if (value) {
                                HapticFeedback.selectionClick();
                              }
                            },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: const Text('Motivational Quotes'),
                            subtitle: const Text('Show quotes on home screen'),
                            value: settings.showMotivationalQuotes,
                            onChanged: (value) {
                              settings.toggleMotivationalQuotes();
                              HapticFeedback.selectionClick();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Distance Unit'),
                            subtitle: Text('Current: ${settings.distanceUnit}'),
                            trailing: DropdownButton<String>(
                              value: settings.distanceUnit,
                              items: ['km', 'mi']
                                  .map((unit) => DropdownMenuItem(
                                        value: unit,
                                        child: Text(unit),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  settings.setDistanceUnit(value);
                                  HapticFeedback.selectionClick();
                                }
                              },
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Weight Unit'),
                            subtitle: Text('Current: ${settings.weightUnit}'),
                            trailing: DropdownButton<String>(
                              value: settings.weightUnit,
                              items: ['kg', 'lb']
                                  .map((unit) => DropdownMenuItem(
                                        value: unit,
                                        child: Text(unit),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  settings.setWeightUnit(value);
                                  HapticFeedback.selectionClick();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 48,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}