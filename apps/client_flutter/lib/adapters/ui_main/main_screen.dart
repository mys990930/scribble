import 'package:flutter/material.dart';
import 'package:scribble/app_shell/routes.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scribble')),
      body: ListView(
        children: [
          _MenuTile(
            icon: Icons.check_circle_outline,
            title: 'Memos',
            onTap: () => Navigator.of(context).pushNamed(Routes.memo),
          ),
          _MenuTile(
            icon: Icons.calendar_today,
            title: 'Calendar',
            onTap: () {},
          ),
          _MenuTile(icon: Icons.schedule, title: 'Daily Plan', onTap: () {}),
          _MenuTile(icon: Icons.note_outlined, title: 'Notes', onTap: () {}),
          _MenuTile(
            icon: Icons.archive_outlined,
            title: 'Archive',
            onTap: () => Navigator.of(context).pushNamed(Routes.archive),
          ),
          const Divider(),
          _MenuTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () => Navigator.of(context).pushNamed(Routes.settings),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
