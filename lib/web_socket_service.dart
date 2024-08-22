import 'dart:convert';
import 'package:ampiiiy/crypto_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://prereg.ex.api.ampiy.com/prices'),
  );

  WebSocketService() {
    _channel.sink.add(jsonEncode({
      "method": "SUBSCRIBE",
      "params": ["all@ticker"],
      "cid": 1,
    }));
  }

//  
Stream<List<Crypto>> get stream {
    return _channel.stream.map((data) {
      final parsedData = jsonDecode(data);
      final List<dynamic> dataList = parsedData['data']; // Adjust based on actual data structure
      return dataList.map((e) => Crypto.fromJson(e)).toList();
    }).handleError((error) {
      print('Error: $error');
      return <Crypto>[]; // Return an empty list in case of error
    });
  }

  void dispose() {
    _channel.sink.close();
  }
}
Stream<List<Crypto>> fetchCryptoDataStream() {
  final webSocketService = WebSocketService();
  return webSocketService.stream;
}