# Panduan Icon Wallet

Berikut adalah daftar nama file icon yang digunakan dalam aplikasi Ollo.
Pastikan file icon Anda diletakkan di folder: `assets/wallets/`

## Daftar Icon yang Sudah Terdaftar di Kode

Aplikasi saat ini mencari file dengan nama-nama berikut. Jika Anda ingin mengganti format (misal dari PNG ke SVG), Anda perlu mengubah juga di file `lib/src/features/wallets/domain/wallet_template.dart`.

### Bank Popular
| Nama Bank | Nama File yang Dicari | Format Saat Ini |
| :--- | :--- | :--- |
| **BRI** | `bri.svg` | **SVG** |
| **Bank Mandiri** | `mandiri.png` | PNG |
| **BCA** | `bca.png` | PNG |
| **BNI** | `bni.png` | PNG |
| **BTN** | `btn.png` | PNG |
| **BSI** | `bsi.png` | PNG |
| **CIMB Niaga** | `cimb_niaga.png` | PNG |
| **OCBC NISP** | `ocbc.png` | PNG |
| **Permata Bank** | `permata.png` | PNG |
| **Danamon** | `danamon.png` | PNG |
| **BTPN / Jenius** | `btpn.png` | PNG |
| **Maybank** | `maybank.png` | PNG |
| **Panin Bank** | `panin.png` | PNG |
| **Bank Mega** | `mega.png` | PNG |
| **Bank Sinarmas** | `sinarmas.png` | PNG |
| **DBS** | `dbs.png` | PNG |
| **Commonwealth** | `commonwealth.png` | PNG |
| **Bank Papua** | `papua.png` | PNG |
| **Bank Jatim** | `jatim.png` | PNG |
| **BTN Syariah** | `btn_syariah.png` | PNG |

### E-Wallets & Digital Bank
| Nama Wallet | Nama File yang Dicari | Format Saat Ini |
| :--- | :--- | :--- |
| **GoPay** | `gopay.png` | PNG |
| **DANA** | `dana.png` | PNG |
| **OVO** | `ovo.png` | PNG |
| **ShopeePay** | `shopeepay.png` | PNG |
| **LinkAja** | `linkaja.png` | PNG |
| **DOKU** | `doku.png` | PNG |
| **Flip** | `flip.png` | PNG |
| **i.Saku** | `isaku.png` | PNG |
| **Blu by BCA** | `blu.png` | PNG |
| **OCTO Mobile** | `octo.png` | PNG |

## Cara Mengganti ke SVG
Jika Anda memiliki file SVG untuk bank lain (misal BCA), lakukan langkah berikut:
1.  Simpan file `bca.svg` ke folder `assets/wallets/`.
2.  Buka file `lib/src/features/wallets/domain/wallet_template.dart`.
3.  Cari baris `WalletTemplate(name: 'BCA', ...)`
4.  Ubah `assets/wallets/bca.png` menjadi `assets/wallets/bca.svg`.
5.  Lakukan **Full Restart** aplikasi.

## Cara Menambah Icon Baru
Jika Anda ingin menambahkan bank baru yang belum ada di daftar:
1.  Simpan file icon (misal `jago.svg`) ke `assets/wallets/`.
2.  Tambahkan entri baru di `lib/src/features/wallets/domain/wallet_template.dart` dalam list `bankTemplates` atau `eWalletTemplates`.
    ```dart
    WalletTemplate(name: 'Bank Jago', assetPath: 'assets/wallets/jago.svg', type: WalletType.bank),
    ```
3.  (Opsional) Tambahkan path file baru ke `pubspec.yaml` jika tidak otomatis terdeteksi.
