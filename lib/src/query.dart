part of rethinkdb;

class _RqlQuery {

  final _RqlTerm _term;
  final Map options;
  Query _protoQuery;
  final Completer _query = new Completer();
  Int64 token;
  var datumValue = [];

  static Int64 tokenCounter = Int64.ONE;

  _RqlQuery(this._term, this.options) {
    _protoQuery = new Query();
    _protoQuery.type = Query_QueryType.START;
    token = tokenCounter++;
    _protoQuery.token =  token;
    _protoQuery.query = _term.build();

    if (options != null) {
      new QueryOptionsBuilder(_protoQuery.globalOptargs).buildProtoOptions(options);
    }
  }
  _RqlQuery.fromConn(_type,this._term,this.options,token){
    _protoQuery = new Query();
    _protoQuery.type = _type;
    if(token == null)
      token = tokenCounter++;
    _protoQuery.token = token;
  }

  _handleProtoResponse(Response protoResponse) {

    if (options != null && options["noReply"]==true) {
      _query.complete();
    } else {
      switch (protoResponse.type) {
        case Response_ResponseType.SUCCESS_ATOM:
          var datumValue = _buildDatumResponseValue(protoResponse.response.first);
          _query.complete(_buildResponse(datumValue));
          break;
        case Response_ResponseType.SUCCESS_SEQUENCE:
          protoResponse.response.forEach((e){
          datumValue.add(_buildDatumResponseValue(e));
          });
          _query.complete(_buildResponse(datumValue));
          break;
        case Response_ResponseType.SUCCESS_PARTIAL:
          protoResponse.response.forEach((e){
          datumValue.add(_buildDatumResponseValue(e));
          });
          break;
        case Response_ResponseType.RUNTIME_ERROR:
          var datum = protoResponse.response.first;
          _query.completeError(datum.rStr);
          break;
        case Response_ResponseType.WAIT_COMPLETE:
          _query.complete();
          break;
        default:
          var datum = protoResponse.response.first;
          _query.completeError(datum.rStr);
          break;
      }
    }
  }

  _buildResponse(datum){
    if(datum is List){
      for(int i=0;i<datum.length;i++){
        datum[i] = _buildResponse(datum[i]);
      }
    }
    if(datum is Map){
      if(datum.containsKey("\$reql_type\$")){
        if(datum["\$reql_type\$"] == "TIME"){
          String s = datum["epoch_time"].toString();
          List l = s.split('.');
          while(l[1].length < 3){
            l[1] = l[1]+"0";
          }
          s = l.join("");
          datum = new DateTime.fromMillisecondsSinceEpoch(int.parse(s));
        }
      }else{
        datum.forEach((k,v){
          if(v is Map){
            datum[k] = _buildResponse(v);
          }else if(v is List){
            datum[k] = _buildResponse(v);
          }
        });
      }
    }

    return datum;
  }
  List<int> get _buffer => _protoQuery.writeToBuffer();
}

