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
  final Map _options = new Map();

  final _replyQueries = new Map<Int64, _RqlQuery>();
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
      _RqlQuery query = _sendQueue.removeFirst();
      Uint8List buffer = query._buffer;
      _socket.add(_toBytes(buffer.length));
      _socket.add(buffer);
      _replyQueries[query.token] = query;
      return query;
    }
  }

  _connect() {
    if(listeners["connect"] != null)
      listeners["connect"].forEach((func)=>func());
    Socket.connect(_host, _port).then((socket) {
      _closing = false;
      _connection_state = _CONNECTED;
      _socket = socket;
      _socketSubscription = _socket.listen(_handleResponse, onError: _handleConnectionError, onDone: _handleClosedSocket);
      _auth();
    }).catchError(_handleConnectionError);
  }

  _auth() {
    _connection_state = _AUTHENTICATING;
    List<int> message =
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

  _handleResponse(Uint8List response) {
    if (_connection_state == _AUTHENTICATED) {
      _handleProtoResponse(response);
    } else {
      _handleAuthResponse(response);
    }
  }

  _handleProtoResponse(Uint8List response) {
   Response protoResponse = new Response.fromBuffer(response.sublist(4));
   _RqlQuery correlatedQuery = _replyQueries.remove(protoResponse.token);
   correlatedQuery._handleProtoResponse(protoResponse);
  }

  _handleAuthResponse(Uint8List response) {
    String response_message = _fromBytes(response);
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

  Future <_RqlQuery> _start(query,[options]) {
    _updateCurrentDatabase(query);
    this._log.fine('Query $query');
    this._sendQueue.addLast(query);
    return this._sendBuffer()._query.future;
  }

  // TODO: look at dart:typed_data as a replacement once it is fully baked
  List<int> _toBytes(int data) {
    List<int> bytes = [];

    // little endian
    bytes.add(data & 0x000000FF);
    bytes.add((data >> 8) & 0x000000FF);
    bytes.add((data >> 16) & 0x000000FF);
    bytes.add((data >> 24) & 0x000000FF);
    return bytes;

  }

  _updateCurrentDatabase(query) {
    if (this.db != null && this.db.isNotEmpty) {
      var pair = new Query_AssocPair();
      pair.key = "db";
      pair.val = new _RqlDatabase(this.db).build();
      query._protoQuery.globalOptargs.add(pair);
    }
  }

  String _fromBytes(List<int> data) {

    StringBuffer sb = new StringBuffer();
    for (int byte in data) {
      if (byte != 0) {
        sb.writeCharCode(byte);
      }
    }
    return sb.toString();
  }
}