class AppSettings {
  final bool notificationsEnabled;
  final bool syncOnCellular;
  final String themeMode;

  const AppSettings({
    required this.notificationsEnabled,
    required this.syncOnCellular,
    required this.themeMode,
  });

  static const defaults = AppSettings(
    notificationsEnabled: true,
    syncOnCellular: false,
    themeMode: 'system',
  );
}
