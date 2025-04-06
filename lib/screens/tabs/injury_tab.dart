import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/theme.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../models/injury_details.dart';

class InjuryTab extends StatefulWidget {
  const InjuryTab({super.key});

  @override
  State<InjuryTab> createState() => _InjuryTabState();
}

class _InjuryTabState extends State<InjuryTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issueController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  DateTime? _selectedDate;
  bool _hasBookedAppointment = false;

  final List<Map<String, dynamic>> commonInjuries = [
    {
      'type': 'Sprains',
      'description': 'Ligament injury from sudden twisting',
      'severity': 'Mild to Severe',
      'icon': Icons.accessibility_new,
    },
    {
      'type': 'Strains',
      'description': 'Muscle or tendon injury from overuse',
      'severity': 'Moderate',
      'icon': Icons.fitness_center,
    },
    {
      'type': 'Fractures',
      'description': 'Bone breaks from impact or stress',
      'severity': 'Severe',
      'icon': Icons.healing,
    },
  ];

  final List<Map<String, dynamic>> careTips = [
    {
      'title': 'Using Straps',
      'content': 'Proper techniques for support and prevention',
      'icon': Icons.wrap_text,
    },
    {
      'title': 'Recovery Sprays',
      'content': 'When and how to use pain relief sprays',
      'icon': Icons.sanitizer,
    },
    {
      'title': 'Rehabilitation',
      'content': 'Essential exercises for recovery',
      'icon': Icons.run_circle,
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    HapticFeedback.mediumImpact();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.cardColor,
              onSurface: AppTheme.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _showInjuryDetails(Map<String, dynamic> injury) {
    HapticFeedback.mediumImpact();
    final details = InjuryDetails.getDetailsForInjury(injury['type']);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(injury['icon'], color: AppTheme.primaryColor, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Severity: ${details.severity}',
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
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(details.description),
                const SizedBox(height: 16),
                Text(
                  'Symptoms',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: details.symptoms.map((symptom) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.circle, size: 8),
                    title: Text(symptom),
                    contentPadding: EdgeInsets.zero,
                  )).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Treatment',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(details.treatment),
                const SizedBox(height: 16),
                Text(
                  'Prevention',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: details.prevention.map((step) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.circle, size: 8),
                    title: Text(step),
                    contentPadding: EdgeInsets.zero,
                  )).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Recovery Time',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(details.recoveryTime),
                const SizedBox(height: 16),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: AnimatedButton(
                                label: 'Book Consultation',
                                icon: Icons.medical_services,
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showDatePicker();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openMap() async {
    HapticFeedback.mediumImpact();
    final url = Uri.parse('https://maps.app.goo.gl/tUbbfRTcJ7VD5JXL8');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open map')),
        );
      }
    }
  }

  void _bookAppointment() {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.mediumImpact();
      setState(() => _hasBookedAppointment = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment request sent! Awaiting confirmation.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget(message: 'Loading injury information...');
    }

    if (_error != null) {
      return CustomErrorWidget(
        message: _error!,
        onRetry: () => setState(() => _error = null),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Injury Management'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Common Injuries',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: commonInjuries.length,
                    itemBuilder: (context, index) {
                      final injury = commonInjuries[index];
                      return InkWell(
                        onTap: () => _showInjuryDetails(injury),
                        child: Container(
                          width: 180,
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(injury['icon'], color: AppTheme.primaryColor, size: 32),
                                  const SizedBox(height: 8),
                                  Text(
                                    injury['type'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(injury['description']),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Severity: ${injury['severity']}',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Care Tips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: careTips.length,
                  itemBuilder: (context, index) {
                    final tip = careTips[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: Icon(tip['icon'], color: AppTheme.primaryColor),
                        title: Text(tip['title']),
                        subtitle: Text(tip['content']),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Opening ${tip['title']} details...'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Doctor Consultation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _issueController,
                          decoration: const InputDecoration(
                            labelText: 'Describe your issue',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.medical_information),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please describe your issue';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: _showDatePicker,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedDate == null
                                      ? 'Select preferred date'
                                      : 'Date: ${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedButton(
                          label: 'Book Consultation',
                          icon: Icons.calendar_today,
                          onPressed: _bookAppointment,
                          width: double.infinity,
                        ),
                        if (_hasBookedAppointment) ...[
                          const SizedBox(height: 24),
                          Card(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pending Appointment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Name: ${_nameController.text}'),
                                  Text('Date: ${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}'),
                                  Text('Status: Awaiting confirmation'),
                                  const SizedBox(height: 16),
                                  InkWell(
                                    onTap: _openMap,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.primaryColor.withOpacity(0.5),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: AppTheme.primaryColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'View Location',
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}