import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/workout_details_dialog.dart';
import '../../models/workout_plan.dart';

class FitnessTab extends StatefulWidget {
  const FitnessTab({super.key});

  @override
  State<FitnessTab> createState() => _FitnessTabState();
}

class _FitnessTabState extends State<FitnessTab> {
  bool _isLoading = false;
  String? _error;

  final List<Map<String, dynamic>> workoutPlans = [
    {
      'title': 'Football Training',
      'type': 'Football Training',
      'description': 'Complete football training session',
      'duration': '60 minutes',
      'difficulty': 'Intermediate',
      'icon': Icons.sports_soccer,
    },
    {
      'title': 'Pre-Game Warmup',
      'type': 'Athletic Warmup',
      'description': 'Essential pre-game warmup routine',
      'duration': '30 minutes',
      'difficulty': 'Beginner',
      'icon': Icons.fitness_center,
    },
    {
      'title': 'Core Strength',
      'type': 'Strength Training',
      'description': 'Core strength and stability workout',
      'duration': '45 minutes',
      'difficulty': 'Advanced',
      'icon': Icons.sports_gymnastics,
    },
  ];

  void _showWorkoutDetails(BuildContext context, Map<String, dynamic> workout) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => WorkoutDetailsDialog(
        plan: WorkoutPlanDetails.getDetailsForPlan(workout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        if (_isLoading) {
          return const LoadingWidget(message: 'Loading fitness plans...');
        }

        if (_error != null) {
          return CustomErrorWidget(
            message: _error!,
            onRetry: () => setState(() => _error = null),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Fitness Plans'),
            elevation: 0,
          ),
          body: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workoutPlans.length + 1,
              itemBuilder: (context, index) {
                if (index == workoutPlans.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: AnimatedButton(
                      label: 'Try AR Movement Tracker',
                      icon: Icons.camera,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Coming Soon!'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.construction,
                                  size: 64,
                                  color: AppTheme.warningColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'AR Movement Tracker is coming soon! We\'re working hard to bring you real-time form tracking and analysis.',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      width: double.infinity,
                    ),
                  );
                }

                final workout = workoutPlans[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () => _showWorkoutDetails(context, workout),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(workout['icon'], color: AppTheme.primaryColor, size: 32),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            workout['title'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            workout['description'],
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 16,
                                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(workout['duration']),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.fitness_center,
                                      size: 16,
                                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(workout['difficulty']),
                                    const Spacer(),
                                    TextButton.icon(
                                      onPressed: () => _showWorkoutDetails(context, workout),
                                      icon: const Icon(Icons.play_arrow),
                                      label: const Text('Start Workout'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}