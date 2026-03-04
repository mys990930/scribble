import 'package:flutter/material.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '장기 기억 노트',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              '이 화면은 장기 기억용 Notes 공간으로 분리됐어.\n메모(To-do)는 Home의 Memos에서 관리해.',
            ),
          ],
        ),
      ),
    );
  }
}
