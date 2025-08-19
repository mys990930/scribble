import 'package:flutter/material.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/daily_plan_screen.dart';
import 'presentation/screens/calendar_screen.dart';
import 'presentation/screens/note_screen.dart';

class Routes {
  static const home = '/';
  static const dailyPlan = '/daily-plan';
  static const calendar = '/calendar';
  static const note = '/note';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scribble',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (_) => const HomeScreen(),
        Routes.dailyPlan: (_) => const DailyPlanScreen(),
        Routes.calendar: (_) => const CalendarScreen(),
        Routes.note: (_) => const NoteScreen(),
      },
    );
  }
}
