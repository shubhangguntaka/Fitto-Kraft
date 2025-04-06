import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/workout_plan.dart';
import '../utils/theme.dart';
import 'animated_button.dart';

class WorkoutDetailsDialog extends StatefulWidget {
  final WorkoutPlanDetails plan;

  const WorkoutDetailsDialog({
    super.key,
    required this.plan,
  });

  @override
  State<WorkoutDetailsDialog> createState() => _WorkoutDetailsDialogState();
}

class _WorkoutDetailsDialogState extends State<WorkoutDetailsDialog> {
  Timer? _timer;
  int _totalSeconds = 0;
  bool _isTimerRunning = false;
  bool _showCongratulations = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _totalSeconds++;
        });
      });
    }
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
    HapticFeedback.mediumImpact();
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get _allStepsCompleted => 
      widget.plan.steps.every((step) => step.isCompleted);

  void _checkStep(int index, bool? value) {
    if (value == null) return;
    
    setState(() {
      widget.plan.steps[index].isCompleted = value;
      if (_allStepsCompleted && !_showCongratulations) {
        _showCongratulations = true;
        _timer?.cancel();
        _isTimerRunning = false;
        _showCongratulationsDialog();
      }
    });
    HapticFeedback.selectionClick();
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.celebration,
              color: AppTheme.accentColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Congratulations!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.successColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ve completed the ${widget.plan.title} workout!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Total Time: ${_formatTime(_totalSeconds)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            AnimatedButton(
              label: 'Close',
              icon: Icons.check_circle,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.plan.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.plan.category} • ${widget.plan.difficulty}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                'Time: ${_formatTime(_totalSeconds)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedButton(
                label: _isTimerRunning ? 'Pause' : 'Start',
                icon: _isTimerRunning ? Icons.pause : Icons.play_arrow,
                onPressed: _toggleTimer,
                width: double.infinity,
              ),
              const SizedBox(height: 24),
              Text(
                'Steps to Complete',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                widget.plan.steps.length,
                (index) => CheckboxListTile(
                  value: widget.plan.steps[index].isCompleted,
                  onChanged: (value) => _checkStep(index, value),
                  title: Text(widget.plan.steps[index].description),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppTheme.primaryColor,
                  checkColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}