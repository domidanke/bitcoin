import 'package:bitcoin/bitcoin.service.dart';
import 'package:flutter/material.dart';

import 'models/wallet_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _walletController = TextEditingController();

  WalletInfo? _walletInfo;
  bool _lndWalletUnlocked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          _walletInfo == null ? 'Load Bitcoin wallet' : 'Unlock Lnd Wallet',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Connected ${BitcoinService().loadedWallet != '' ? 'using ${BitcoinService().loadedWallet}' : ''}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.greenAccent),
              ),
              if (BitcoinService().loadedWallet == '')
                Row(
                  children: [
                    // Input field for the wallet.
                    Expanded(
                      child: TextField(
                        controller: _walletController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Wallet Name',
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Button to load the wallet.
                    ElevatedButton(
                      onPressed: () async {
                        await _loadWallet();
                      },
                      child: const Text('Load Wallet'),
                    ),
                  ],
                ),
              const SizedBox(
                height: 12,
              ),
              if (_walletInfo != null) _walletInfo!.getInfoWidget(),
              const SizedBox(
                height: 32,
              ),
              if (_walletInfo != null && !_lndWalletUnlocked)
                ElevatedButton(
                    onPressed: () async {
                      final unlocked = await BitcoinService().unlockLndWallet();
                      setState(() {
                        _lndWalletUnlocked = unlocked;
                      });
                    },
                    child: const Text('Unlock Lnd Wallet')),
              const SizedBox(
                height: 32,
              ),
              if (_walletInfo != null && !_lndWalletUnlocked)
                const Text(
                  'Now, run your lnd service using lnd while in the same network and unlock your current lnd wallet',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              if (_walletInfo != null && !_lndWalletUnlocked)
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                    'lnd.conf:\n\n[Bitcoin]\nbitcoin.active=1\nbitcoin.signet=1\nbitcoin.node=bitcoind\n\n[Bitcoind]\nbitcoind.rpchost=localhost\nbitcoind.rpcuser=dom_ln\nbitcoind.rpcpass=123123\nbitcoind.zmqpubrawblock=tcp://127.0.0.1:28332\nbitcoind.zmqpubrawtx=tcp://127.0.0.1:28333\n\n[Application Options]\nrestlisten=0.0.0.0:8080\n'),
                              ),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      size: 32,
                    )),
              if (_lndWalletUnlocked)
                const Text(
                  'Lnd Wallet unlocked! You can now make transactions',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.greenAccent),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future _loadWallet() async {
    final result = await BitcoinService().loadWallet(_walletController.text);
    setState(() {
      _walletInfo = result;
    });
  }
}
