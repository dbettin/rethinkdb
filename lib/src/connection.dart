part of rethinkdb;


class Connection {
  static const String DEFAULT_HOST = "127.0.0.1";
  static const num DEFAULT_PORT = 28015;
  static const String DEFAULT_AUTH_KEY = "";
  static const num _PROTOCOL_VERSION = 1915781601; // v2

  static const int _NOT_CONNECTED = 1;
  static const int _CONNECTED = 2;
  static const int _AUTHENTICATING = 3;
  static const int _AUTHENTICATED = 4;
  static const int _CLOSED = 5;

  final String _host;
  final num _port;
  final String _authKey;
  String db;
  final Completer _connected;
  final Map<int, _RqlQuery> _queries = new Map<int, _RqlQuery>();
  Socket _socket;
  int _connection_state = _NOT_CONNECTED;

  Connection._internal(this._connected, this.db, this._host, this._port, this._authKey) {
    _connect();
  }

  static Future<Connection> connect(String db, String host, num port, String authKey) {

    var connected = new Completer();
    var connection = new Connection._internal(connected, db, host, port,  authKey);
    return connected.future;
  }

  close() {
    if (_connection_state != _CLOSED && _socket != null) {
      _socket.destroy();
    }
  }

  reconnect() {
    close();
    _connect();
  }

  use(dbName) => db = dbName;

  _sendQuery(_RqlQuery query) {
    _queries[query.token] = query;
    var buffer = query._buffer;
    _socket.add(_toBytes(buffer.length));
    _socket.add(buffer);
  }

  _connect() {

    Socket.connect(_host, _port).then((socket) {
      _connection_state = _CONNECTED;
      _socket = socket;
      _socket.listen(_handleResponse, onError: _handleConnectionError, onDone: _handleClosedSocket);
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

    // correlate query
    var correlatedQuery = _queries[protoResponse.token.getInt8(0)];
    correlatedQuery._handleProtoResponse(protoResponse);
    _queries.remove(protoResponse.token);
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


