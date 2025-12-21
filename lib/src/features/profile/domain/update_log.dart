class UpdateLog {
  final String version;
  final DateTime date;
  final List<String> changes;
  final bool isBeta;

  const UpdateLog({
    required this.version,
    required this.date,
    required this.changes,
    this.isBeta = true,
  });

  // Sample data
  static List<UpdateLog> get logs => [
    UpdateLog(
      version: 'Beta 0.5.2',
      date: DateTime(2025, 12, 21),
      changes: [
        'Fixed Quick Record bug where draft disappears after saving.',
        'Fixed Onboarding issue where duplicate wallets were created.',
      ],
    ),
    UpdateLog(
      version: 'Beta 0.5.1',
      date: DateTime(2025, 12, 20),
      changes: [
        'Added Mandarin language support for Quick Record.',
        'Updated Help & Support FAQs.',
      ],
    ),
     UpdateLog(
      version: 'Beta 0.5.0',
      date: DateTime(2025, 12, 16),
      changes: [
        'Refined Quick Record UI/UX.',
        'Fixed Transaction Title Localization.',
      ],
    ),
  ];
}
