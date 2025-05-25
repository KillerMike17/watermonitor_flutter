import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  late IO.Socket _socket;
  final String clientId;

  // Stream controller to broadcast sensor data to listeners
  final StreamController<Map<String, dynamic>> _sensorController =
      StreamController.broadcast();

  WebSocketService(this.clientId);

  Stream<Map<String, dynamic>> get sensorStream => _sensorController.stream;

      
  void connect(String url) {
    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

  



    _socket.onConnect((_) {
      print('Socket connected');
      // Register the client with the backend
      _socket.emit('register', {'clientId': clientId});
    });

    _socket.on('sensor-data', (data) {
      print('Received sensor-data: $data');
      if (data is Map) {
        _sensorController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket.onError((error) {
      print('Socket error: $error');
    });
  }

  

  void dispose() {
    _sensorController.close();
    _socket.dispose();
  }
}
