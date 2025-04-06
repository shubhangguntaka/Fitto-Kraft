class InjuryDetails {
  final String title;
  final String description;
  final String treatment;
  final List<String> symptoms;
  final List<String> prevention;
  final String recoveryTime;
  final String severity;

  InjuryDetails({
    required this.title,
    required this.description,
    required this.treatment,
    required this.symptoms,
    required this.prevention,
    required this.recoveryTime,
    required this.severity,
  });

  static InjuryDetails getDetailsForInjury(String type) {
    switch (type) {
      case 'Sprains':
        return InjuryDetails(
          title: 'Sprains',
          description: 'A sprain occurs when ligaments (tissues that connect bones) are stretched or torn.',
          treatment: '1. Rest the injured area\n2. Apply ice\n3. Compression\n4. Elevation\n5. Over-the-counter pain medication',
          symptoms: [
            'Pain',
            'Swelling',
            'Bruising',
            'Limited mobility',
            'Hearing/feeling a "pop" at time of injury'
          ],
          prevention: [
            'Proper warm-up',
            'Use supportive footwear',
            'Strengthen muscles around joints',
            'Practice proper technique',
            'Use protective equipment'
          ],
          recoveryTime: '2-8 weeks depending on severity',
          severity: 'Mild to Severe',
        );
      case 'Strains':
        return InjuryDetails(
          title: 'Strains',
          description: 'A strain is an injury to muscles or tendons (tissues that connect muscles to bones).',
          treatment: '1. Rest\n2. Ice therapy\n3. Compression bandage\n4. Anti-inflammatory medication\n5. Gentle stretching',
          symptoms: [
            'Muscle pain and tenderness',
            'Weakness in affected muscle',
            'Muscle spasms',
            'Limited range of motion',
            'Swelling'
          ],
          prevention: [
            'Proper stretching',
            'Gradual intensity increase',
            'Regular rest periods',
            'Good posture',
            'Core strengthening'
          ],
          recoveryTime: '3-6 weeks',
          severity: 'Moderate',
        );
      case 'Fractures':
        return InjuryDetails(
          title: 'Fractures',
          description: 'A fracture is a complete or partial break in a bone.',
          treatment: '1. Immobilization\n2. Pain management\n3. Surgery (if needed)\n4. Physical therapy\n5. Follow-up care',
          symptoms: [
            'Severe pain',
            'Swelling',
            'Deformity',
            'Inability to use affected area',
            'Bruising'
          ],
          prevention: [
            'Adequate calcium intake',
            'Regular bone-strengthening exercise',
            'Proper safety equipment',
            'Safe training techniques',
            'Regular health check-ups'
          ],
          recoveryTime: '6-12 weeks or more',
          severity: 'Severe',
        );
      default:
        return InjuryDetails(
          title: type,
          description: 'General sports injury',
          treatment: 'Seek professional medical advice',
          symptoms: ['Pain', 'Discomfort'],
          prevention: ['Proper warm-up', 'Good technique'],
          recoveryTime: 'Varies',
          severity: 'Unknown',
        );
    }
  }
}