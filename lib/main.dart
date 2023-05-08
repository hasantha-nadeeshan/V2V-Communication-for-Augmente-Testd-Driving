import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = "Waiting for messages...";
  RawDatagramSocket? _socket;

  Future<void> _startListening() async {
    try {
     // final address = InternetAddress("192.168.1.35");
    //  final port = 65154;
      _socket = await RawDatagramSocket.bind("169.254.129.201", 5005);

      _socket!.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = _socket!.receive();
          if (datagram != null) {
            setState(() {
              _message = "Received message: ${String.fromCharCodes(datagram.data)}";
            });
          }
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    super.dispose();
    _socket?.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDP Listener',
      home: Scaffold(
        appBar: AppBar(
          title: Text('UDP Listener'),
        ),
        body: Center(
          child: Text(_message),
        ),
      ),
    );
  }
}
