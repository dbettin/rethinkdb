part of rethinkdb;

class _Connection {
  static const String DEFAULT_HOST = "127.0.0.1";
  static const num DEFAULT_PORT = 28015;
  static const String DEFAULT_AUTH_KEY = "";
  static const num _PROTOCOL_VERSION = 1915781601; // v2

  static const int _NOT_CONNECTED = 1;
  static const int _CONNECTED = 2;
  static const int _AUTHENTICATING = 3;
  static const int _AUTHENTICATED = 4;
  static const int _CLOSED = 5;

  String _host;
  num _port;
  String _authKey;
  String db;
  Completer _connected;
  Socket _socket;
  int _connection_state = _NOT_CONNECTED;
  final Map <String, List> listeners = new Map<String, List>();

  final _replyQueries = new Map<int, _RqlQuery>();
  final _log= new Logger('Connection');
  final _sendQueue = new Queue<_RqlQuery>();
  bool _closing = false;
  StreamSubscription<List<int>> _socketSubscription;

   Future<_Connection> connect(String db, String host, num port, String authKey) {
     this._connected = new Completer();
     this.db = db;
     this._host = host;
     this._port = port;
     this._authKey = authKey;

     _connect();

    return _connected.future;
  }

  close() {
    if(listeners["close"] != null)
      listeners["close"].forEach((func)=>func());
    _closing = true;
    while (!_sendQueue.isEmpty){
      _sendBuffer();
    }
    _sendQueue.clear();
    _socket.close();
    _replyQueries.clear();
  }

  reconnect() {
    close();
    _connect();
  }
  on(String key, Function val)
  {
    addListener(key,val);
  }

  addListener(String key, Function val)
  {
    List currentListeners = [];
    if(listeners != null && listeners[key] != null)
      listeners[key].forEach((element)=>currentListeners.add(element));

    currentListeners.add(val);
    listeners[key] = currentListeners;
  }

  use(dbName) => db = dbName;

  noreplyWait(callback){

  }
  _sendBuffer() {
    if (!_sendQueue.isEmpty) {
      var query = _sendQueue.removeFirst();
      var buffer = query._buffer;
      _socket.add(_toBytes(buffer.length));
      _socket.add(buffer);
      _replyQueries[query.token] = query;
    }
  }

  _connect() {
    if(listeners["connect"] != null)
      listeners["connect"].forEach((func)=>func());
    Socket.connect(_host, _port).then((socket) {
      _connection_state = _CONNECTED;
      _socket = socket;
      _socketSubscription = _socket.listen(_handleResponse, onError: _handleConnectionError, onDone: _handleClosedSocket);
      _auth();
    }).catchError(_handleConnectionError);
  }

  _auth() {
    _connection_state = _AUTHENTICATING;
    var message =
        _toBytes(_PROTOCOL_VERSION)
        ..addAll(_toBytes(_authKey.length))
        ..addAll(_authKey.codeUnits);
    _socket.add(message);
  }

  _handleConnectionError(error) {
    if(listeners["error"] != null)
      listeners["error"].forEach((func)=>func(error));

    if (error is! RqlConnectionException) {
      error = new RqlConnectionException("Failed to connect with message: ${error.message}.", error);
    }

    close();

    if (!_connected.isCompleted) {
      _connected.completeError(error);
    } else {
      throw error;
    }

  }

  _handleResponse(List<int> response) {
    if (_connection_state == _AUTHENTICATED) {
      _handleProtoResponse(response);
    } else {
      _handleAuthResponse(response);
    }
  }

  _handleProtoResponse(List<int> response) {
   var protoResponse = new Response.fromBuffer(response.getRange(4, response.length).toList());

  var correlatedQuery = _replyQueries[protoResponse.token.toInt()];
  _replyQueries.remove(protoResponse.token.toInt());
    correlatedQuery._handleProtoResponse(protoResponse);


  }
  _handleAuthResponse(List<int> response) {
    var response_message = _fromBytes(response);

    if (response_message == "SUCCESS") {
      _connection_state = _AUTHENTICATED;

      if (!_connected.isCompleted)
        _connected.complete(this);

    } else {
      _handleConnectionError( new RqlConnectionException('Connection failed with error: $response_message'));
    }
  }

  _handleClosedSocket() {
    _connection_state = _CLOSED;
  }


  // TODO: look at dart:typed_data as a replacement once it is fully baked
  List<int> _toBytes(int data) {
    var bytes = [];

    // little endian
    bytes.add(data & 0x000000FF);
    bytes.add((data >> 8) & 0x000000FF);
    bytes.add((data >> 16) & 0x000000FF);
    bytes.add((data >> 24) & 0x000000FF);
    return bytes;

  }

  String _fromBytes(List<int> data) {

    var sb = new StringBuffer();
    for (var byte in data) {
      if (byte != 0) {
        sb.writeCharCode(byte);
      }
    }
    return sb.toString();
  }
}


class MongoMessageHandler {
  final _log = new Logger('MongoMessageTransformer');
  final converter = new PacketConverter();
//  final debugData = new File('debug_data1.bin').openSync(mode: FileMode.WRITE);
void handleData(List<int> data, EventSink<MongoReplyMessage> sink) {
  //    debugData.writeFromSync(data);
  //    debugData.flushSync();
  //_log.fine('handleData length=${data.length} $data');
    converter.addPacket(data);
    while (!converter.messages.isEmpty) {
      var buffer = new BsonBinary.from(converter.messages.removeFirst());
      MongoReplyMessage reply = new MongoReplyMessage();
      reply.deserialize(buffer);
      _log.fine(reply.toString());
      sink.add(reply);
    }
  }
  void handleDone(EventSink<MongoReplyMessage> sink) {
    if (!converter.isClear) {
      _log.warning('Invalid state of PacketConverter in handleDone: $converter');
    }
    sink.close();
  }
  StreamTransformer<List<int>, MongoReplyMessage> get transformer => new StreamTransformer<List<int>, MongoReplyMessage>.fromHandlers(
      handleData: handleData,handleDone: handleDone);
}

/**
_Connection() {
serverConfig = new ServerConfig();
}
Future<_Connection> connect(){
Completer completer = new Completer();
Socket.connect(serverConfig.host, serverConfig.port).then((Socket _socket) {
_connection_state = _CONNECTED;
/* Socket connected. */
socket = _socket;
_auth();
_socketSubscription = socket
.transform(new RqlMessageHandler().transformer)
.listen(_receiveReply,onError: (e) {
print("Socket error ${e}");
completer.completeError(e);
});
connected = true;
completer.complete(this);
_connection_state = _AUTHENTICATED;
}).catchError( (err) {
completer.completeError(err);
});
return completer.future;
}
void _receiveReply(RqlQueryRunner reply) {
print("ok");
_log.fine(reply.toString());
Completer completer = _replyCompleters.remove(reply);
if (completer != null){
_log.fine('Completing $reply');
completer.complete(reply);
//TODO
}
else {
if (!_closing) {
_log.info("Unexpected respondTo: $reply");
}
}
}
_auth() {
_connection_state = _AUTHENTICATING;
var message =
_toBytes(_PROTOCOL_VERSION)
..addAll(_toBytes(serverConfig.authKey.length))
..addAll(serverConfig.authKey.codeUnits);
socket.add(message);
}
use(dbName) => serverConfig.db = dbName;
on(String key, Function val) => addListener(key,val);

addListener(String key, Function val)
{
List currentListeners = [];
if(listeners != null && listeners[key] != null)
listeners[key].forEach((element)=>currentListeners.add(element));

currentListeners.add(val);
listeners[key] = currentListeners;
}

_sendBuffer(){
_log.fine('_sendBuffer ${!_sendQueue.isEmpty}');
if (!_sendQueue.isEmpty) {
_RqlQuery rqlMessage = _sendQueue.removeFirst();
var buffer = rqlMessage._buffer;
socket.add(_toBytes(buffer.length));
socket.add(buffer);
}
}

_handleResponse(List<int> response) {
if (_connection_state == _AUTHENTICATED) {
_handleProtoResponse(response);
} else {
_handleAuthResponse(response);
}
}
_handleProtoResponse(List<int> response) {
var protoResponse = new Response.fromBuffer(response.getRange(4, response.length).toList());

// correlate query
var correlatedQuery = _queries[protoResponse.token.toInt()];
correlatedQuery._handleProtoResponse(protoResponse);
_queries.remove(protoResponse.token);
}


}



List<int> _toBytes(int data) {
var bytes = [];

// little endian
bytes.add(data & 0x000000FF);
bytes.add((data >> 8) & 0x000000FF);
bytes.add((data >> 16) & 0x000000FF);
bytes.add((data >> 24) & 0x000000FF);
return bytes;

}**/