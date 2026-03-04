import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 이후 실제 캘린더 뷰(월/주) 연결
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const Center(child: Text('캘린더 기능은 곧 연결됩니다.')),
    );
  }
}
