part of rethinkdb;

class _RqlQuery {

  final _RqlTerm _term;
  final Map options;
  Query _protoQuery;
  final Completer _query = new Completer();
  Int64 token;

  static Int64 tokenCounter = Int64.ONE;

  _RqlQuery(this._term, this.options) {
    _protoQuery = new Query();
    _protoQuery.type = Query_QueryType.START;
    token = tokenCounter++;
    _protoQuery.token =  token;
    _protoQuery.query = _term.build();
    print(_protoQuery);

    if (options != null) {
      new QueryOptionsBuilder(_protoQuery.globalOptargs).buildProtoOptions(options);
    }
  }
  _handleProtoResponse(Response protoResponse) {
    if (options != null && options["noReply"]==true) {
      _query.complete();
    } else {
      switch (protoResponse.type) {
        case Response_ResponseType.SUCCESS_ATOM:
          var datumValue = _buildDatumResponseValue(protoResponse.response.first);
          _query.complete(datumValue);
          break;
        case Response_ResponseType.SUCCESS_SEQUENCE:
          var datumValue = [];
          protoResponse.response.forEach((e){
          datumValue.add(_buildDatumResponseValue(e));
          });
          _query.complete(datumValue);
          break;
        case Response_ResponseType.SUCCESS_PARTIAL:
          var datumValue = [];
          protoResponse.response.forEach((e){
          datumValue.add(_buildDatumResponseValue(e));
          });
          _query.complete(datumValue);
          break;
        case Response_ResponseType.RUNTIME_ERROR:
          var datum = protoResponse.response.first;
          _query.completeError(datum.rStr);
          break;
        default:
          var datum = protoResponse.response.first;
          _query.completeError(datum.rStr);
          break;
      }
    }
  }

  List<int> get _buffer => _protoQuery.writeToBuffer();
}

