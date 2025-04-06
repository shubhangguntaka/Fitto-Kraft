import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/fitness_tracker_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize providers
  final settingsProvider = SettingsProvider();
  await settingsProvider.initialize();
  
  final fitnessTrackerProvider = FitnessTrackerProvider();
  await fitnessTrackerProvider.initialize();

  runApp(MyApp(
    settingsProvider: settingsProvider,
    fitnessTrackerProvider: fitnessTrackerProvider,
  ));
}

class MyApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final FitnessTrackerProvider fitnessTrackerProvider;

  const MyApp({
    super.key,
    required this.settingsProvider,
    required this.fitnessTrackerProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: fitnessTrackerProvider),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Fitto Kraft',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
