import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/theme.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class TournamentsTab extends StatefulWidget {
  const TournamentsTab({super.key});

  @override
  State<TournamentsTab> createState() => _TournamentsTabState();
}

class _TournamentsTabState extends State<TournamentsTab> {
  bool _isLoading = false;
  String? _error;

  final List<Map<String, dynamic>> upcomingEvents = [
    {
      'title': 'City Marathon 2025',
      'date': 'April 15, 2025',
      'location': 'Central Park',
      'type': 'Marathon',
      'coordinates': {'lat': 40.785091, 'lng': -73.968285},
    },
    {
      'title': 'Regional Swimming Championship',
      'date': 'April 20, 2025',
      'location': 'Aquatic Center',
      'type': 'Swimming',
      'coordinates': {'lat': 40.758896, 'lng': -73.985130},
    },
    {
      'title': 'Basketball League Finals',
      'date': 'May 1, 2025',
      'location': 'Sports Arena',
      'type': 'Basketball',
      'coordinates': {'lat': 40.750568, 'lng': -73.993519},
    },
  ];

  final List<Map<String, dynamic>> trainingPrograms = [
    {
      'title': 'Summer Sports Camp',
      'duration': '2 months',
      'type': 'Internship',
      'eligibility': 'Age 16-20',
      'deadline': 'May 15, 2025',
    },
    {
      'title': 'Professional Coaching',
      'duration': '6 months',
      'type': 'Training',
      'eligibility': 'All ages',
      'deadline': 'June 1, 2025',
    },
    {
      'title': 'Elite Athlete Program',
      'duration': '1 year',
      'type': 'Scholarship',
      'eligibility': 'Performance-based',
      'deadline': 'July 15, 2025',
    },
  ];

  void _openMapsForEvent(Map<String, dynamic> coordinates) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${coordinates['lat']},${coordinates['lng']}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget(message: 'Loading tournaments and events...');
    }

    if (_error != null) {
      return CustomErrorWidget(
        message: _error!,
        onRetry: () => setState(() => _error = null),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tournaments & Training'),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming Events'),
              Tab(text: 'Training Programs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming Events Tab
            AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  final event = upcomingEvents[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  event['title'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('${event['date']} • ${event['type']}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.location_on),
                                  onPressed: () => _openMapsForEvent(event['coordinates']),
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.place_outlined),
                                    const SizedBox(width: 8),
                                    Text(event['location']),
                                    const Spacer(),
                                    AnimatedButton(
                                      label: 'Register',
                                      icon: Icons.how_to_reg,
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        // TODO: Implement registration
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Registration coming soon!'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
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
            // Training Programs Tab
            AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: trainingPrograms.length,
                itemBuilder: (context, index) {
                  final program = trainingPrograms[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  program['title'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('${program['type']} • ${program['duration']}'),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person_outline),
                                        const SizedBox(width: 8),
                                        Text('Eligibility: ${program['eligibility']}'),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.event),
                                        const SizedBox(width: 8),
                                        Text('Deadline: ${program['deadline']}'),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    AnimatedButton(
                                      label: 'Apply Now',
                                      icon: Icons.send,
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        // TODO: Implement application process
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Application process coming soon!'),
                                          ),
                                        );
                                      },
                                      width: double.infinity,
                                    ),
                                  ],
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
          ],
        ),
      ),
    );
  }
}