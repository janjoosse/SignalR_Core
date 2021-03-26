import 'dart:async';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalrConnectionService {

  late HubConnection _connection;

  StreamController<String> _message = StreamController<String>.broadcast();
  Stream<String> get message => _message.stream; 

  Future<void> startConnection() async {
    _connection = HubConnectionBuilder()
      .withUrl('https://localhost:5001/messagehub', 
        HttpConnectionOptions(
          client: IOClient(HttpClient()..badCertificateCallback = (x, y, z) => true),
          transport: HttpTransportType.webSockets,
          logging: (level, message) => print(message),
        ))
      .build(); 

    if (_connection.state == HubConnectionState.disconnected) {
      await _connection.start();
      _connection.on('ReceiveMessage', (args) => _message.sink.add(args![0]));
    }
  }

  Future<void> closeConnection() async {
    if (_connection.state == HubConnectionState.connected) {
      _connection.off('ReceiveMessage');
      _connection.stop();
    } 
  }
}