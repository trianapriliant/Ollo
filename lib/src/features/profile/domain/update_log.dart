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
      version: 'Beta 0.6.3',
      date: DateTime(2025, 12, 27),
      changes: [
        'NEW: Iconoir Icon Pack - Modern line-style icon alternative.',
        'NEW: Icon Pack switcher in Settings → Appearance (Material Icons / Iconoir).',
        'Migrated: Dashboard Menu, Bottom Navigation, Profile Screen icons to dynamic icon system.',
        'Migrated: Import Wallet Templates, Color Palette, Backup & Recovery screens.',
        'Migrated: Data Export/Import screens with wallet & category selector icons.',
        'Migrated: Bug Report screen with feature selector icons.',
        'Migrated: Cards screens (Add/Edit Card, My Cards) with dynamic icons.',
        'NEW: Icon mappings for help, restore, file_download, file_upload, send, info, folder.',
        'Improved: Differentiated subcategory icons (lunch/dinner/eateries, books/courses, weekly/monthly).',
      ],
    ),
    UpdateLog(
      version: 'Beta 0.6.2',
      date: DateTime(2025, 12, 27),
      changes: [
        'Modernized: All PopupMenuButton menus with rounded corners, icon containers, and dividers.',
        'Modernized: Budget, Wishlist, Savings, Recurring, Bills, Cards screens with functional sorting.',
        'Modernized: Debts screen popup menu with Sort by Amount toggle.',
        'Modernized: Smart Notes and Reimburse screens now have triple-dot menus.',
        'Modernized: Wallet Detail popup (Update Balance, Edit, Delete) with colored icons.',
        'Modernized: Update Balance dialog with premium design and wallet name display.',
        'NEW: Sort options toggle on/off with checkmark indicator and snackbar feedback.',
        'NEW: Thousand separator formatting in Update Balance input field.',
        'Improved: All popup menus now have consistent Home navigation option.',
      ],
    ),
    UpdateLog(
      version: 'Beta 0.6.1',
      date: DateTime(2025, 12, 26),
      changes: [
        'NEW: Card Tabs - My Cards screen now has Bank, E-Wallet, Blockchain tabs.',
        'NEW: Blockchain card type added for crypto wallets.',
        'NEW: Fruits subcategory under Food & Drink with voice patterns (EN/ID).',
        'Modernized: Savings Deposit/Withdraw dialog with icon header and horizontal wallet selector.',
        'Modernized: Percentage shortcuts (5%, 10%, 25%, 50%) based on savings target amount.',
        'Improved: Category migration logic - subcategory icons auto-update on app update.',
        'Improved: Add/Edit Card now shows Blockchain option in provider picker.',
        'Fixed: Blockchain tab only shows when user has blockchain cards.',
      ],
    ),
    UpdateLog(
      version: 'Beta 0.6.0',
      date: DateTime(2025, 12, 25),
      changes: [
        '🎄 Christmas Release! Major Voice Transfer Feature.',
        'NEW: Voice Transfer - Say "Transfer 100k dari BCA ke Mandiri admin 5k" to create transfers.',
        'NEW: Smart transfer detection with source/destination wallet parsing.',
        'NEW: Admin fee extraction from voice input.',
        'NEW: Category hints in voice help showing expected detection result.',
        'Improved: Transfer review UI with visual source → destination flow.',
        'Improved: Add Transaction screen now scrollable, buttons pinned at bottom.',
        'Improved: Reduced spacing throughout for better space utilization.',
        'Fixed: Transfer draft now correctly navigates to Add Transaction screen.',
        'Fixed: Unified app version across all screens (About, Profile, Bug Report).',
        'Updated: Voice help examples now include 5 transfer examples.',
      ],
    ),
    UpdateLog(
      version: 'Beta 0.5.7',
      date: DateTime(2025, 12, 24),
      changes: [
        'Enhanced Onboarding: Added new "Quick Record" page highlighting voice and scan features.',
        'Enhanced Onboarding: Added Currency selection step before wallet setup.',
        'Enhanced Onboarding: Modernized Profile setup with borderless inputs and gradient avatar.',
        'Enhanced Onboarding: Swipe left/right to navigate between steps.',
        'Enhanced Onboarding: Voice language selector now shows English first, removed "Recommended" badge.',
        'Enhanced Onboarding: Reordered pages (Quick Record → Statistics → Management → Savings).',
        'Fixed: Duplicate Cash wallet issue when completing onboarding.',
        'Fixed: Transaction double-submit bug with loading state on NumPad.',
        'Improved: Profile page menu order (Data Management first) with reduced spacing.',
        'Improved: Send Feedback now supports Telegram and Email in addition to WhatsApp.',
        'Improved: Category order - Friend moved before Personal, Income reordered (Salary first).',
        'Improved: Debts screen now separates active and completed debts visually.',
        'Improved: Debt payments now show edit/delete options for better history management.',
      ],
    ),
    UpdateLog(
      version: 'Beta 0.5.6',
      date: DateTime(2025, 12, 23),
      changes: [
        'New Feature: Import Wallet Icon Pack from ZIP files (Settings → Wallet Icons).',
        'New Feature: Custom wallet icon upload from gallery.',
        'Modernized Add Wallet type selector with horizontal pill-style chips.',
        'Wallet templates now dynamically loaded from imported icon packs.',
        'Added support for SVG icons from local storage (imported packs).',
        'VIP codes updated to 16-character format with 50 available codes.',
        'Prepared app for Play Store release: wallet icons now require import.',
      ],
    ),
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
