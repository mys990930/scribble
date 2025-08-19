import 'package:flutter/material.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 이후 노트 목록/편집 화면 연결
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const Center(
        child: Text('노트 기능은 곧 연결됩니다.'),
      ),
    );
  }
}
