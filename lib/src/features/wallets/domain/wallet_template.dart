import 'package:flutter/material.dart';
import 'wallet.dart';

class WalletTemplate {
  final String name;
  final String assetPath;
  final WalletType type;

  const WalletTemplate({
    required this.name,
    required this.assetPath,
    required this.type,
  });
}

const List<WalletTemplate> bankTemplates = [
  WalletTemplate(name: 'Bank Jago', assetPath: 'assets/wallets/jago.svg', type: WalletType.bank),
  WalletTemplate(name: 'Bank Mandiri', assetPath: 'assets/wallets/mandiri.png', type: WalletType.bank),
  WalletTemplate(name: 'BCA', assetPath: 'assets/wallets/bca.svg', type: WalletType.bank),
  WalletTemplate(name: 'BRI', assetPath: 'assets/wallets/bri.svg', type: WalletType.bank),
  WalletTemplate(name: 'BNI', assetPath: 'assets/wallets/bni.svg', type: WalletType.bank),
  WalletTemplate(name: 'BSI', assetPath: 'assets/wallets/bsi.svg', type: WalletType.bank),
  WalletTemplate(name: 'BTN', assetPath: 'assets/wallets/btn.svg', type: WalletType.bank),
  WalletTemplate(name: 'CIMB Niaga', assetPath: 'assets/wallets/cimb_niaga.svg', type: WalletType.bank),
  WalletTemplate(name: 'Danamon', assetPath: 'assets/wallets/danamon.svg', type: WalletType.bank),
  WalletTemplate(name: 'Permata Bank', assetPath: 'assets/wallets/permata.svg', type: WalletType.bank),
  WalletTemplate(name: 'OCBC NISP', assetPath: 'assets/wallets/ocbc.svg', type: WalletType.bank),
  WalletTemplate(name: 'BTPN / Jenius', assetPath: 'assets/wallets/btpn.svg', type: WalletType.bank),
];

const List<WalletTemplate> eWalletTemplates = [
  WalletTemplate(name: 'GoPay', assetPath: 'assets/wallets/gopay.svg', type: WalletType.ewallet),
  WalletTemplate(name: 'OVO', assetPath: 'assets/wallets/ovo.svg', type: WalletType.ewallet),
  WalletTemplate(name: 'DANA', assetPath: 'assets/wallets/dana.svg', type: WalletType.ewallet),
  WalletTemplate(name: 'ShopeePay', assetPath: 'assets/wallets/shopeepay.svg', type: WalletType.ewallet),
];
