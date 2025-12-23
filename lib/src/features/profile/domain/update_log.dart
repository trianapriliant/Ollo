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
      version: 'Beta 0.5.5',
      date: DateTime(2025, 12, 23),
      changes: [
        'Modernized all delete confirmation dialogs with consistent design (icons, soft shadows, modern buttons).',
        'Added 6 new gradient themes: Argon, Velvet Sun, Summer, Broken Hearts, Relay, Cinnamint.',
        'Fixed wallet card overflow by stacking Nett Balance and Active Debts vertically.',
        'Modern delete dialogs now apply to: Transaction, Wallet, Budget, Card, Wishlist, Debt, Bill, Saving, Recurring, Category, Sub-Category.',
      ],
    ),
    UpdateLog(
      version: 'Beta 0.5.4',
      date: DateTime(2025, 12, 22),
      changes: [
        'Modernized UI: Add Card (Provider, Type, Category selectors) with bottom sheet pickers.',
        'Modernized UI: Smart Notes wallet selector now uses modern picker.',
        'Modernized UI: Edit Transaction category selector with scrollable bottom sheet.',
        'Modernized UI: Bug Report screen with softer borders and modern styling.',
        'Modernized UI: Color Palette dots now use subtle shadows instead of outlines.',
        'Modernized UI: Edit Category screen with modern color, icon, type, and sub-category selectors.',
        'Modernized UI: Delete confirmation dialogs now use modern design with icons and soft shadows.',
        'Fixed: Category duplication bug when editing existing categories.',
        'Fixed: Category re-appearing after restart due to corrupted externalId.',
        'Fixed: Add Card optional fields (Label, Branch) no longer show validation errors.',
        'Improved: Category sync now auto-repairs corrupted data on app startup.',
        'Improved: Delete category now shows warning with linked transaction count.',
        'Improved: Delete sub-category now shows confirmation with linked transaction count.',
        'Improved: Transaction now stores category name as snapshot for historical accuracy.',
      ],
    ),
    UpdateLog(
      version: 'Beta 0.5.3',
      date: DateTime(2025, 12, 22),
      changes: [
        'Added new "Friend" expense category (Transfer, Treat, Refund, Loan, Gift).',
        'Improved category sync: New categories auto-appear on app update.',
        'Friend category & Color Palette localized to 7 languages.',
        'Fixed Budget category names not showing in correct language.',
        'Enhanced Quick Record patterns with 130+ new English keywords.',
        'Added Friend patterns to all 5 Quick Record languages.',
        'New Bug Report feature: Report issues directly via Email, WhatsApp, or Telegram.',
      ],
    ),


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
