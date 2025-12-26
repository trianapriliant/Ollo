# 📋 Ollo Update Checklist

Referensi cepat untuk setiap rilis/update aplikasi.

---

## 🔢 Version Update

| File | Field | Contoh |
|------|-------|--------|
| `pubspec.yaml` | `version:` | `0.6.0+3` → `0.6.1+4` |

> ⚠️ **Penting:** versionCode (angka setelah +) **HARUS naik terus**, tidak boleh sama atau turun!

---

## 📝 Update Log

| File | Action |
|------|--------|
| `lib/src/features/profile/domain/update_log.dart` | Tambah entry baru di paling atas |

```dart
UpdateLog(
  version: 'Beta 0.6.1',
  date: DateTime(2025, 12, 26),
  changes: [
    'NEW: Fitur baru...',
    'Improved: Perbaikan...',
    'Fixed: Bug fix...',
  ],
),
```

---

## 🌐 Localization

Jika menambah **teks baru** yang tampil ke user:

| File | Action | Command |
|------|--------|---------|
| `lib/l10n/app_en.arb` | Tambah key baru (English) | - |
| `lib/l10n/app_id.arb` | Tambah key baru (Indonesian) | - |
| `lib/l10n/app_zh.arb` | Tambah key baru (Mandarin) | - |
| - | Regenerate | `flutter gen-l10n` |

> 💡 Template ARB adalah `app_en.arb`. Key baru HARUS ada di sini dulu!

---

## 🎤 Quick Record Patterns

Jika menambah **keyword deteksi** untuk voice/scan:

| File | Bahasa |
|------|--------|
| `lib/src/features/quick_record/domain/patterns/patterns_id.dart` | Indonesian |
| `lib/src/features/quick_record/domain/patterns/patterns_en.dart` | English |
| `lib/src/features/quick_record/domain/patterns/patterns_zh.dart` | Mandarin |

---

## 📂 Category Updates

Jika menambah/mengubah **kategori atau subkategori**:

| File | Purpose |
|------|---------|
| `lib/src/features/categories/data/default_categories.dart` | Daftar kategori default |
| Patterns files (lihat di atas) | Keywords untuk deteksi |
| Localization files (lihat di atas) | Nama kategori yang di-localize |

---

## 💳 Wallet Updates

Jika menambah **template wallet baru**:

| File | Purpose |
|------|---------|
| `lib/src/features/wallets/application/wallet_template_service.dart` | Template bawaan (jika ada) |
| Icon pack ZIP | Untuk icon custom |

---

## 💾 Backup & Data Export

Jika menambah **field baru pada model/entity**:

| File | Purpose |
|------|---------|
| `lib/src/features/backup/application/backup_service.dart` | Pastikan field baru ikut di-export/import |
| `lib/src/features/backup/application/data_export_service.dart` | Format export CSV/Excel |

> ⚠️ **Penting:** Field baru pada Transaction, Wallet, Category, dll harus ditambahkan ke logic backup agar data tidak hilang saat restore!

**Checklist:**
- [ ] Field baru ada di `toJson()` dan `fromJson()` 
- [ ] Export CSV termasuk field baru
- [ ] Import bisa handle file lama (backward compatible)

---

## 🗺️ Feedback & Roadmap

Jika **fitur baru selesai** atau **ada rencana fitur baru**:

| File | Purpose |
|------|---------|
| `lib/src/features/settings/presentation/roadmap_screen.dart` | Update status fitur (planned → in progress → done) |

**Status Options:**
- `planned` - Direncanakan
- `inProgress` - Sedang dikerjakan
- `completed` - Sudah selesai

```dart
RoadmapItem(
  title: 'Voice Transfer',
  description: 'Transfer antar wallet dengan suara',
  status: RoadmapStatus.completed,  // ← Update ini!
  version: '0.6.0',
),
```

---

## 🗄️ Database Schema

Jika menambah **field baru pada Isar model**:

| File | Action |
|------|--------|
| Model file (`.dart`) | Tambah field + annotation |
| - | Run `flutter pub run build_runner build` |
| - | Increment schema version jika breaking change |

> ⚠️ **Breaking change** = mengubah/menghapus field yang sudah ada. Perlu migration!

---

## 📱 Home Widgets (Android)

Jika menambah/mengubah **widget Android**:

| File | Purpose |
|------|---------|
| `android/app/src/main/res/xml/widget_info*.xml` | Widget configuration |
| `android/app/src/main/res/layout/*.xml` | Widget layout |
| `android/app/src/main/res/drawable/widget_preview*.png` | Preview di widget picker |
| `lib/src/features/home_widget/` | Widget logic Flutter |

**Widgets yang ada:**
- Monthly Summary Widget
- Budget Widget  
- Gradient Daily Expense Widget
- Quick Record Widget

---

## 🏆 Gamification

Jika menambah **achievement atau challenge baru**:

| File | Purpose |
|------|---------|
| `lib/src/features/gamification/domain/` | Achievement definitions |
| `lib/src/features/gamification/presentation/gamification_screen.dart` | UI display |
| Localization files | Achievement names & descriptions |

---

## 💎 Subscription & Premium

Jika mengubah **fitur premium atau kode VIP**:

| File | Purpose |
|------|---------|
| `lib/src/features/subscription/domain/vip_codes.dart` | Daftar kode VIP |
| `lib/src/features/subscription/application/revenuecat_service.dart` | Premium logic |
| `lib/src/features/subscription/presentation/premium_screen.dart` | Premium benefits UI |

---

## 🎨 Android Resources

Jika mengubah **icon, splash, atau branding**:

| File | Purpose |
|------|---------|
| `android/app/src/main/res/mipmap-*/` | App icon (semua ukuran) |
| `android/app/src/main/res/drawable/launch_background.xml` | Splash screen |
| `assets/images/` | In-app images |
| `assets/logo.png` | Logo utama |

> 💡 **Tip:** Gunakan Android Asset Studio untuk generate icon semua ukuran.

---

## 🎓 Onboarding

Jika menambah **step onboarding baru**:

| File | Purpose |
|------|---------|
| `lib/src/features/onboarding/presentation/onboarding_screen.dart` | Main onboarding flow |
| `lib/src/features/onboarding/presentation/onboarding_*_screen.dart` | Individual screens |
| Localization files | Onboarding texts |

---

## 📊 Statistics & Reports

Jika menambah **chart atau insight baru**:

| File | Purpose |
|------|---------|
| `lib/src/features/statistics/presentation/` | Chart screens |
| `lib/src/features/statistics/application/statistics_provider.dart` | Data calculations |

---

## 🧪 Pre-Release Checklist

- [ ] Version updated di `pubspec.yaml`
- [ ] Update log ditambahkan
- [ ] Localization strings lengkap (EN, ID, ZH)
- [ ] `flutter gen-l10n` sudah dijalankan
- [ ] `flutter analyze` tidak ada error
- [ ] Test di device fisik
- [ ] Build APK: `flutter build apk --release`

---

## 🚀 Quick Commands

```bash
# Regenerate localization
flutter gen-l10n

# Check for issues
flutter analyze

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Run on device
flutter run
```

---

*Last updated: 2025-12-25 (v0.6.0)*
