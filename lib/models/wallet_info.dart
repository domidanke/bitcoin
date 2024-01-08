import 'package:flutter/material.dart';

class WalletInfo {
  WalletInfo(
      {required this.walletName,
      required this.walletVersion,
      required this.format,
      required this.balance,
      required this.unconfirmedBalance,
      required this.immatureBalance,
      required this.txCount,
      required this.keyPoolSize,
      required this.payTxFee,
      required this.privateKeysEnabled});

  WalletInfo.fromJson(Map<String, Object?> json)
      : this(
            walletName: json['walletname']! as String,
            walletVersion: json['walletversion']! as int,
            format: json['format']! as String,
            balance: json['balance'] as double,
            unconfirmedBalance: json['unconfirmed_balance'] as double,
            immatureBalance: json['immature_balance'] as double,
            txCount: json['txcount']! as int,
            keyPoolSize: json['keypoolsize']! as int,
            payTxFee: json['paytxfee'] as double,
            privateKeysEnabled: json['private_keys_enabled'] as bool);

  final String walletName;
  final int walletVersion;
  final String format;
  final double balance;
  final double unconfirmedBalance;
  final double immatureBalance;
  final int txCount;
  final int keyPoolSize;
  final double payTxFee;
  final bool privateKeysEnabled;

  Column getInfoWidget() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Wallet Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(walletName),
          ],
        ),
        Row(
          children: [
            const Text(
              'Type:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(format),
          ],
        ),
        Row(
          children: [
            const Text(
              'Balance:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(balance.toString()),
          ],
        ),
        Row(
          children: [
            const Text(
              'Unconf. Balance:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(unconfirmedBalance.toString()),
          ],
        ),
        Row(
          children: [
            const Text(
              'Immat. Balance:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(immatureBalance.toString()),
          ],
        ),
        Row(
          children: [
            const Text(
              'Tx Count:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(txCount.toString()),
          ],
        ),
        Row(
          children: [
            const Text(
              'Keypool Size:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(keyPoolSize.toString()),
          ],
        ),
        Row(
          children: [
            const Text(
              'Paytx Fee:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(payTxFee.toString()),
          ],
        ),
        Row(
          children: [
            const Text(
              'Priv. Keys enabled:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(privateKeysEnabled.toString()),
          ],
        ),
      ],
    );
  }
}
