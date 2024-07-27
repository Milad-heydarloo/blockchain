
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Wallet ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WalletListPage(),
    );
  }
}

class WalletListPage extends StatefulWidget {
  @override
  _WalletListPageState createState() => _WalletListPageState();
}

class _WalletListPageState extends State<WalletListPage> {
  final List<String> privateKeys = [



    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364100",
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd036411e",
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364120",
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364122",
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364124",


  ];

  int _currentIndex = 0;
  late Timer _timer;
  final List<Map<String, dynamic>> _wallets = [];

  final String _rpcUrl = "https://holesky.infura.io/v3/12dacb31ace644f18865ce80aea2496d";
  late Web3Client _ethClient;

  @override
  void initState() {
    super.initState();
    _ethClient = Web3Client(_rpcUrl, http.Client());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_currentIndex < privateKeys.length) {
        String privateKey = privateKeys[_currentIndex];
        await _fetchWalletInfo(privateKey);
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  Future<void> _fetchWalletInfo(String privateKey) async {
    try {
      EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
      EthereumAddress address = await credentials.extractAddress();
      EtherAmount balance = await _ethClient.getBalance(address);
      double balanceInEth = balance.getValueInUnit(EtherUnit.ether).toDouble();
      _wallets.add({
        'privateKey': privateKey,
        'address': address.hex,
        'balance': balanceInEth
      });


      print('Private Key: $privateKey');
      print('Address: ${address.hex}');
      print('Balance: $balanceInEth ETH');
      print(balanceInEth > 0 ? 'biofpo' : '');

      setState(() {});
    } catch (e) {
      print("Error fetching wallet info: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet List'),
      ),
      body: ListView.builder(
        itemCount: _wallets.length,
        itemBuilder: (context, index) {
          var wallet = _wallets[index];
          return ListTile(
            title: Text('Address: ${wallet['address']}'),
            subtitle: Text('Balance: ${wallet['balance']} ETH' + (wallet['balance'] > 0 ? ' biofpo' : '')),
          );
        },
      ),
    );
  }
}

