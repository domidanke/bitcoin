import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/wallet_info.dart';
// bitcoin.conf
// signet=1
// server=1
// daemon=1
// txindex=1
// rpcuser=dom_ln
// rpcpassword=123123
// zmqpubrawblock=tcp://127.0.0.1:28332
// zmqpubrawtx=tcp://127.0.0.1:28333
// listen=1
// torpassword=123123
// proxy=127.0.0.1:9050
// onlynet=onion
// fallbackfee=0.0001

// lnd.conf
// [Bitcoin]
// bitcoin.active=1
// bitcoin.signet=1
// bitcoin.node=bitcoind
//
// [Bitcoind]
// bitcoind.rpchost=localhost
// bitcoind.rpcuser=dom_ln
// bitcoind.rpcpass=123123
// bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332
// bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333
//
// [tor]
// tor.active=true
// tor.password=123123
// tor.socks=127.0.0.1:9050
// tor.streamisolation=true
// tor.v3=true

class BitcoinService {
  factory BitcoinService() {
    return _singleton;
  }
  BitcoinService._internal();
  static final BitcoinService _singleton = BitcoinService._internal();

  String _ipAddress = '';
  String _username = '';
  String _password = '';
  String loadedWallet = '';

  Future<bool> connectBitcoin(
    String ip,
    String username,
    String password,
  ) async {
    // curl -u dom_ln:123123 -H "Content-Type: application/json" -d '{"method":"getblockchaininfo","params":[],"id":"1"}' http://127.0.0.1:38332
    final url = Uri.parse('http://$ip:38332');

    final body = jsonEncode({
      'method': 'getblockchaininfo',
      'params': [],
      'id': 1,
    });

    final response = await http.post(
      url,
      body: body,
      encoding: Encoding.getByName('utf-8'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
      },
    );

    if (response.statusCode == 200) {
      _ipAddress = ip;
      _username = username;
      _password = password;
      return true;
    } else {
      throw Exception('Failed to send RPC request: ${response.statusCode}');
    }
  }

  Future<WalletInfo> loadWallet(String walletName) async {
    final url = Uri.parse('http://$_ipAddress:38332');
    final body = jsonEncode({
      'method': 'loadwallet',
      'params': [walletName],
      'id': 1,
    });

    final response = await http.post(
      url,
      body: body,
      encoding: Encoding.getByName('utf-8'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
      },
    );

    if (response.statusCode == 200) {
      loadedWallet = walletName;
      return await getWalletInfo();
    } else {
      throw Exception('Failed to load wallet: ${response.statusCode}');
    }
  }

  Future<WalletInfo> getWalletInfo() async {
    final url = Uri.parse('http://$_ipAddress:38332');
    final body = jsonEncode({
      'method': 'getwalletinfo',
      'params': [],
      'id': 1,
    });

    final response = await http.post(
      url,
      body: body,
      encoding: Encoding.getByName('utf-8'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
      },
    );

    if (response.statusCode == 200) {
      return WalletInfo.fromJson(jsonDecode(response.body)['result']);
    } else {
      throw Exception('Failed to send RPC request: ${response.statusCode}');
    }
  }

  Future<bool> unlockLndWallet() async {
    final url = Uri.parse('https://$_ipAddress:8080/v1/unlockwallet');

    final body = jsonEncode({
      "wallet_password": base64.encode(utf8.encode("Dominik18!")),
      "recovery_window": 1,
      "channel_backups": null,
      "stateless_init": true
    });

    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'rejectUnauthorized': 'false'
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to send RPC request: ${response.statusCode}');
    }
  }
}
