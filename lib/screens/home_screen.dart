import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../utils/theme.dart';
import '../widgets/haptic_tab_wrapper.dart';
import 'tabs/fitness_tab.dart';
import 'tabs/injury_tab.dart';
import 'tabs/tournaments_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _quotes = [
    "The only bad workout is the one that didn't happen.",
    "Your body can stand almost anything. It's your mind you have to convince.",
    "The harder you work, the better you feel.",
    "Don't wish for it, work for it.",
    "Strength does not come from physical capacity. It comes from an indomitable will.",
  ];
  String _currentQuote = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    _updateQuote();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      if (settings.useHapticFeedback) {
        HapticFeedback.selectionClick();
      }
    }
  }

  void _updateQuote() {
    setState(() {
      _currentQuote = _quotes[DateTime.now().millisecondsSinceEpoch % _quotes.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Theme(
          data: settings.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          child: Scaffold(
            body: Column(
              children: [
                if (settings.showMotivationalQuotes)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.format_quote),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _currentQuote,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            if (settings.useHapticFeedback) {
                              HapticFeedback.selectionClick();
                            }
                            _updateQuote();
                          },
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      HapticTabWrapper(child: FitnessTab()),
                      HapticTabWrapper(child: InjuryTab()),
                      HapticTabWrapper(child: TournamentsTab()),
                      HapticTabWrapper(child: ProfileTab()),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.fitness_center),
                    text: 'Fitness',
                  ),
                  Tab(
                    icon: Icon(Icons.healing),
                    text: 'Injury',
                  ),
                  Tab(
                    icon: Icon(Icons.emoji_events),
                    text: 'Tournaments',
                  ),
                  Tab(
                    icon: Icon(Icons.person),
                    text: 'Profile',
                  ),
                ],
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}