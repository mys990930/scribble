import 'package:flutter/material.dart';
import '../../app.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _HomeCard(
        icon: Icons.calendar_today,
        title: 'Daily Plan',
        subtitle: '일상 루틴 관리',
        onTap: () => Navigator.pushNamed(context, Routes.dailyPlan),
      ),
      _HomeCard(
        icon: Icons.event_note,
        title: 'Calendar',
        subtitle: '일정/프로젝트 보기',
        onTap: () => Navigator.pushNamed(context, Routes.calendar),
      ),
      _HomeCard(
        icon: Icons.note_alt,
        title: 'Notes',
        subtitle: '메모·마크다운',
        onTap: () => Navigator.pushNamed(context, Routes.note),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;
            final crossAxisCount = isWide ? 3 : 1;
            final childAspectRatio = isWide ? 1.3 : 2.8;

            return GridView.builder(
              itemCount: cards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (_, i) => cards[i],
            );
          },
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: cs.primaryContainer,
                child: Icon(icon, color: cs.onPrimaryContainer, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
