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
  WalletTemplate(name: 'Bank Mandiri', assetPath: 'assets/wallets/mandiri.png', type: WalletType.bank),
  WalletTemplate(name: 'BRI', assetPath: 'assets/wallets/bri.svg', type: WalletType.bank),
  WalletTemplate(name: 'BCA', assetPath: 'assets/wallets/bca.png', type: WalletType.bank),
  WalletTemplate(name: 'BNI', assetPath: 'assets/wallets/bni.png', type: WalletType.bank),
  WalletTemplate(name: 'BTN', assetPath: 'assets/wallets/btn.png', type: WalletType.bank),
  WalletTemplate(name: 'BSI', assetPath: 'assets/wallets/bsi.png', type: WalletType.bank),
  WalletTemplate(name: 'CIMB Niaga', assetPath: 'assets/wallets/cimb_niaga.png', type: WalletType.bank),
  WalletTemplate(name: 'OCBC NISP', assetPath: 'assets/wallets/ocbc.png', type: WalletType.bank),
  WalletTemplate(name: 'Permata Bank', assetPath: 'assets/wallets/permata.png', type: WalletType.bank),
  WalletTemplate(name: 'Danamon', assetPath: 'assets/wallets/danamon.png', type: WalletType.bank),
  WalletTemplate(name: 'BTPN / Jenius', assetPath: 'assets/wallets/btpn.png', type: WalletType.bank),
  WalletTemplate(name: 'Maybank', assetPath: 'assets/wallets/maybank.png', type: WalletType.bank),
  WalletTemplate(name: 'Panin Bank', assetPath: 'assets/wallets/panin.png', type: WalletType.bank),
  WalletTemplate(name: 'Bank Mega', assetPath: 'assets/wallets/mega.png', type: WalletType.bank),
  WalletTemplate(name: 'Bank Sinarmas', assetPath: 'assets/wallets/sinarmas.png', type: WalletType.bank),
  WalletTemplate(name: 'DBS', assetPath: 'assets/wallets/dbs.png', type: WalletType.bank),
  WalletTemplate(name: 'Commonwealth', assetPath: 'assets/wallets/commonwealth.png', type: WalletType.bank),
  WalletTemplate(name: 'Bank Papua', assetPath: 'assets/wallets/papua.png', type: WalletType.bank),
  WalletTemplate(name: 'Bank Jatim', assetPath: 'assets/wallets/jatim.png', type: WalletType.bank),
  WalletTemplate(name: 'BTN Syariah', assetPath: 'assets/wallets/btn_syariah.png', type: WalletType.bank),
];

const List<WalletTemplate> eWalletTemplates = [
  WalletTemplate(name: 'GoPay', assetPath: 'assets/wallets/gopay.png', type: WalletType.ewallet),
  WalletTemplate(name: 'DANA', assetPath: 'assets/wallets/dana.png', type: WalletType.ewallet),
  WalletTemplate(name: 'OVO', assetPath: 'assets/wallets/ovo.png', type: WalletType.ewallet),
  WalletTemplate(name: 'ShopeePay', assetPath: 'assets/wallets/shopeepay.png', type: WalletType.ewallet),
  WalletTemplate(name: 'LinkAja', assetPath: 'assets/wallets/linkaja.png', type: WalletType.ewallet),
  WalletTemplate(name: 'DOKU', assetPath: 'assets/wallets/doku.png', type: WalletType.ewallet),
  WalletTemplate(name: 'Flip', assetPath: 'assets/wallets/flip.png', type: WalletType.ewallet),
  WalletTemplate(name: 'i.Saku', assetPath: 'assets/wallets/isaku.png', type: WalletType.ewallet),
  WalletTemplate(name: 'Blu by BCA', assetPath: 'assets/wallets/blu.png', type: WalletType.bank), // Digital Bank
  WalletTemplate(name: 'OCTO Mobile', assetPath: 'assets/wallets/octo.png', type: WalletType.bank),
];
