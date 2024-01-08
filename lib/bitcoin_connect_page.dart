import 'package:bitcoin/bitcoin.service.dart';
import 'package:flutter/material.dart';

class BitcoinConnectPage extends StatefulWidget {
  const BitcoinConnectPage({super.key});

  @override
  State<BitcoinConnectPage> createState() => _BitcoinConnectPageState();
}

class _BitcoinConnectPageState extends State<BitcoinConnectPage> {
  TextEditingController ipAddressController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          'Connect to Bitcoin',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                focusNode: _focusNode1,
                controller: ipAddressController,
                decoration: const InputDecoration(
                  labelText: 'IP Address using Port 38332',
                ),
              ),
              TextField(
                focusNode: _focusNode2,
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                focusNode: _focusNode3,
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  _focusNode1.unfocus();
                  _focusNode2.unfocus();
                  _focusNode3.unfocus();
                  _sendRequest();
                },
                child: const Text('Connect'),
              ),
              const SizedBox(
                height: 32,
              ),
              const Text(
                'First, run your bitcoin service using bitcoind.\nWhile in the same network, use your local IP address and the username and password from your bitcoin.conf file',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                                  'bitcoin.conf:\n\nsignet=1\nserver=1\ntxindex=1\nrpcuser=dom_ln\nrpcpassword=123123\n\n[signet]\nrpcallowip=0.0.0.0/0\nrpcbind=0.0.0.0\nzmqpubrawblock=tcp://127.0.0.1:28332\nzmqpubrawtx=tcp://127.0.0.1:28333\nfallbackfee=0.0001'),
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    size: 32,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future _sendRequest() async {
    final response = await BitcoinService().connectBitcoin(
        ipAddressController.text,
        usernameController.text,
        passwordController.text);

    if (mounted && response) {
      Navigator.pushNamed(context, 'home');
    }
  }
}
