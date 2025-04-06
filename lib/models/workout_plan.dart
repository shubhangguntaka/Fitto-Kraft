class WorkoutStep {
  String description;
  bool isCompleted;

  WorkoutStep({
    required this.description,
    this.isCompleted = false,
  });
}

class WorkoutPlanDetails {
  final String title;
  final String type;
  final String description;
  final List<WorkoutStep> steps;
  final String duration;
  final String difficulty;
  final String category;

  WorkoutPlanDetails({
    required this.title,
    required this.type,
    required this.description,
    required this.steps,
    required this.duration,
    required this.difficulty,
    required this.category,
  });

  static WorkoutPlanDetails getDetailsForPlan(Map<String, dynamic> plan) {
    switch (plan['type']) {
      case 'Football Training':
        return WorkoutPlanDetails(
          title: 'Football Practice Session',
          type: 'Football Training',
          description: 'Complete football training session focusing on core skills',
          duration: '60 minutes',
          difficulty: 'Intermediate',
          category: 'Sports Specific',
          steps: [
            WorkoutStep(description: 'Warm-up jog (10 minutes)'),
            WorkoutStep(description: 'Dynamic stretching'),
            WorkoutStep(description: 'Ball control drills (15 minutes)'),
            WorkoutStep(description: 'Passing practice (15 minutes)'),
            WorkoutStep(description: 'Shooting drills (10 minutes)'),
            WorkoutStep(description: 'Mini-game situation (15 minutes)'),
            WorkoutStep(description: 'Cool-down stretches'),
          ],
        );
      
      case 'Athletic Warmup':
        return WorkoutPlanDetails(
          title: 'Pre-Competition Warmup',
          type: 'Athletic Warmup',
          description: 'Complete warmup routine for athletic performance',
          duration: '30 minutes',
          difficulty: 'Beginner',
          category: 'Preparation',
          steps: [
            WorkoutStep(description: 'Light jogging (5 minutes)'),
            WorkoutStep(description: 'Dynamic leg swings'),
            WorkoutStep(description: 'Arm circles and shoulder mobility'),
            WorkoutStep(description: 'Hip mobility exercises'),
            WorkoutStep(description: 'Sprint build-ups (4x30m)'),
            WorkoutStep(description: 'Plyometric exercises'),
            WorkoutStep(description: 'Sport-specific movements'),
          ],
        );

      case 'Strength Training':
        return WorkoutPlanDetails(
          title: 'Core Strength Workout',
          type: 'Strength Training',
          description: 'Build core strength and stability',
          duration: '45 minutes',
          difficulty: 'Advanced',
          category: 'Strength',
          steps: [
            WorkoutStep(description: 'Warmup (5 minutes)'),
            WorkoutStep(description: 'Planks (3 sets x 1 minute)'),
            WorkoutStep(description: 'Russian twists (3 sets x 20 reps)'),
            WorkoutStep(description: 'Dead bugs (3 sets x 12 reps)'),
            WorkoutStep(description: 'Bird dogs (3 sets x 10 reps each side)'),
            WorkoutStep(description: 'Ab rollouts (3 sets x 10 reps)'),
            WorkoutStep(description: 'Cool down stretches'),
          ],
        );

      default:
        return WorkoutPlanDetails(
          title: plan['title'] ?? 'Custom Workout',
          type: plan['type'] ?? 'General',
          description: plan['description'] ?? 'Custom workout plan',
          duration: plan['duration'] ?? '30 minutes',
          difficulty: plan['difficulty'] ?? 'Intermediate',
          category: plan['category'] ?? 'General',
          steps: [
            WorkoutStep(description: 'Warm up'),
            WorkoutStep(description: 'Main exercise routine'),
            WorkoutStep(description: 'Cool down'),
          ],
        );
    }
  }
}