part of rethinkdb;

abstract class RqlQueryRunner {
  Future run(Connection connection, [Map options]) {
    var query = new _RqlQuery(this, connection, options);
    return query._execute();
  }
}

class _RqlQuery {

  final _ResponseTerm _term;
  final Connection _connection;
  final Map options;
  Query _protoQuery;
  final Completer _query = new Completer();
  String currentDatabase;
  int token;

  static int tokenCounter = 1;

  _RqlQuery(this._term, this._connection, this.options) {
    _protoQuery = new Query();
    _protoQuery.type = Query_QueryType.START;
    token = tokenCounter++;
    _protoQuery.token = new ByteData.view(new Int64List.fromList([token]).buffer);
    _protoQuery.query = _term._buildProtoTerm();

    if (options != null) {
      new QueryOptionsBuilder(_protoQuery.globalOptargs).buildProtoOptions(options);
    }
  }

  _handleProtoResponse(Response protoResponse) {
    if (options != null && options["noReply"]) {
      _query.complete();
    } else {
      switch (protoResponse.type) {
        case Response_ResponseType.SUCCESS_ATOM:
          var datumValue = _buildDatumResponseValue(protoResponse.response.first);
          _query.complete(_term.buildQueryResponse(datumValue));
          break;
        case Response_ResponseType.RUNTIME_ERROR:
          var datum = protoResponse.response.first;
          _query.completeError(new RqlQueryException(datum.rStr));
          break;
        default:
          var datum = protoResponse.response.first;
          _query.completeError(new RqlDriverException(datum.rStr));
          break;
      }
    }
  }

  Future _execute() {
    _updateCurrentDatabase();
    _connection._sendQuery(this);
    return _query.future;
  }

  _updateCurrentDatabase() {
    if (_connection.db != null && _connection.db.isNotEmpty) {
      var pair = new Query_AssocPair();
      pair.key = "db";
      pair.val = new RqlDatabase(_connection.db)._buildProtoTerm();
      _protoQuery.globalOptargs.add(pair);
    }
  }

  List<int> get _buffer => _protoQuery.writeToBuffer();
}

