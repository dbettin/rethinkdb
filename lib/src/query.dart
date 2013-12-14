part of rethinkdb;

abstract class RqlQueryRunner {
  Future run(_Connection connection, [Map options]) {
    var query = new _RqlQuery(this, connection, options);
    return query._execute();
  }

  _RqlCount count() => new _RqlCount(this);

  _RqlSum sum(String attr) => new _RqlSum(attr);

  _RqlAvg avg(String attr) => new _RqlAvg(attr);

  _RqlAdd add(number) => new _RqlAdd(this,number);

  _RqlSub sub(number) => new _RqlSub(this,number);

  _RqlMul mul(number) => new _RqlMul(this,number);

  _RqlDiv div(number) => new _RqlDiv(this,number);

  _RqlMod mod(number) => new _RqlMod(this,number);

  _RqlAnd and(b) => new _RqlAnd(this,b);

  _RqlOr or(b) => new _RqlOr(this,b);

  _RqlEq eq(val) => new _RqlEq(this,val);

  _RqlNe ne(val) => new _RqlNe(this,val);

  _RqlGt gt(val) => new _RqlGt(this,val);

  _RqlGe ge(val) => new _RqlGe(this,val);

  _RqlLt lt(val) => new _RqlLt(this,val);

  _RqlLe le(val) => new _RqlLe(this,val);

  _RqlNot not() => new _RqlNot(this);

  _RqlOrderBy orderBy(attrs) => new _RqlOrderBy(_listify(attrs));

  _RqlGroupBy groupBy(String attr,reductionObj) => new _RqlGroupBy(this,attr,reductionObj);

  _RqlAsc asc(String attr) => new _RqlAsc(attr);

  _RqlDesc desc(String attr) => new _RqlDesc(attr);

  _RqlInfo info() => new _RqlInfo(this);

  _RqlInTimezone inTimezone(tz) => new _RqlInTimezone(this,tz);

  _RqlTimezone timezone() => new _RqlTimezone(this);

  _RqlDuring during(start,end,[options]) => new _RqlDuring(this,start,end,options);

  _RqlDate date() => new _RqlDate(this);

  _RqlTimeOfDay timeOfDay() => new _RqlTimeOfDay(this);

  _RqlYear year() => new _RqlYear(this);

  _RqlMonth month() => new _RqlMonth(this);

  _RqlDay day() => new _RqlDay(this);

  _RqlDayOfWeek dayOfWeek() => new _RqlDayOfWeek(this);

  _RqlDayOfYear dayOfYear() => new _RqlDayOfYear(this);

  _RqlHours hours() => new _RqlHours(this);

  _RqlMinutes minutes() => new _RqlMinutes(this);

  _RqlSeconds seconds() => new _RqlSeconds(this);

  _RqlToISO8601 toISO8601() => new _RqlToISO8601(this);

  _RqlToEpochTime toEpochTime() => new _RqlToEpochTime(this);

  _RqlIndexCreate indexCreate(index,[indexFunction]) => new _RqlIndexCreate(this,index,indexFunction);

  _RqlIndexDrop indexDrop(index) => new _RqlIndexDrop(this,index);

  _RqlIndexList indexList() => new _RqlIndexList(this);

  _RqlInnerJoin innerJoin(otherSequence, predicate) => new _RqlInnerJoin(this,otherSequence,predicate);

  _RqlOuterJoin outerJoin(otherSequence, predicate) => new _RqlOuterJoin(this,otherSequence,predicate);

  _RqlEqJoin eqJoin(leftAttr,otherTable,[options]) => new _RqlEqJoin(this,leftAttr,otherTable,options);

  _RqlZip zip() => new _RqlZip(this);

  _RqlMap map(mappingFunction) => new _RqlMap(this,mappingFunction);

  _RqlConcatMap concatMap(mappingFunction) => new _RqlConcatMap(this,mappingFunction);

  _RqlIndexesOf indexesOf(obj) => new _RqlIndexesOf(this,obj);

  _RqlReduce reduce(reductionFunction,[base]) => new _RqlReduce(this,reductionFunction,base);

  _RqlGroupedMapReduce groupedMapReduce(grouping, mapping, reduction, [base]) => new _RqlGroupedMapReduce(this,grouping,mapping,reduction,base);

  _RqlMatch match(String regex) => new _RqlMatch(this,regex);

  _RqlForEach forEach(write_query) => new _RqlForEach(this,write_query);

  _RqlTableCreateFromDb tableCreate(tableName,[options]) => new _RqlTableCreateFromDb(this,tableName,options);

  _RqlIndexStatus indexStatus([index]) => new _RqlIndexStatus(_listify(index));


  _RqlIndexWait indexWait([index]) =>  new _RqlIndexWait(_listify(index));

  _RqlInsert insert(records,[options]) => new _RqlInsert(this,records,options);

  _RqlSync sync() => new _RqlSync(this);

  _RqlDelete delete([options]) => new _RqlDelete(this,options);

  _RqlGet get(key) => new _RqlGet(this,key);

  _RqlGetAll getAll(keys,[options]) => new _RqlGetAll(_listify(keys),options);

  _RqlBetween between(lowerKey,upperKey,[options]) => new _RqlBetween(this,lowerKey,upperKey,options);

  _RqlUpdate update(expr,[options]) => new _RqlUpdate(this,expr,options);

  _RqlReplace replace(expr, [options]) => new _RqlReplace(this,expr,options);

  _RqlFilter filter(expr,[options]) => new _RqlFilter(this,expr,options);

  _RqlWithFields withFields([fields]) => new _RqlWithFields(_listify(fields));

  _RqlSkip skip(int i) => new _RqlSkip(this,i);

  _RqlLimit limit(int i) => new _RqlLimit(this,i);

  _RqlSlice slice(int start,[int end]) => new _RqlSlice(this,start,end);

  _RqlNth nth(int index) => new _RqlNth(this,index);

  _RqlIsEmpty isEmpty() => new _RqlIsEmpty(this);

  _RqlUnion union(sequence) => new _RqlUnion(this,sequence);

  _RqlSample sample(int i) => new _RqlSample(this,i);

  _RqlDistinct distinct() => new _RqlDistinct(this);

  _RqlContains contains(items) => new _RqlContains(_listify(items));

  _RqlPluck pluck(items) => new _RqlPluck(_listify(items));

  _RqlWithout without(items) => new _RqlWithout(_listify(items));

  _RqlMerge merge(obj) => new _RqlMerge(this,obj);

  _RqlAppend append(val) => new _RqlAppend(this,val);

  _RqlPrepend prepend(val) => new _RqlPrepend(this,val);

  _RqlDifference difference(List ar) => new _RqlDifference(this,ar);

  _RqlSetInsert setInsert(val) => new _RqlSetInsert(this,val);

  _RqlSetUnion setUnion(ar) => new _RqlSetUnion(this,ar);

  _RqlSetIntersection setIntersection(ar) => new _RqlSetIntersection(this,ar);

  _RqlSetDifference setDifference(ar) => new _RqlSetDifference(this,ar);

  _RqlHasFields hasFields(items) => new _RqlHasFields(_listify(items));

  _RqlInsertAt insertAt(index,value) => new _RqlInsertAt(this,index,value);

  _RqlSpliceAt spliceAt(index,ar) => new _RqlSpliceAt(this,index,ar);

  _RqlDeleteAt deleteAt(index,[end]) => new _RqlDeleteAt(this,index,end);

  _RqlChangeAt changeAt(index,value) => new _RqlChangeAt(this,index,value);

  _RqlKeys keys() => new _RqlKeys(this);

  _RqlDefault defaultTo(value) => new _RqlDefault(this,value);

  _RqlCoerceTo coerceTo(String type) => new _RqlCoerceTo(this,type);

  _RqlTypeOf typeOf() => new _RqlTypeOf(this);

  _RqlTableList tableList() => new _RqlTableList(this);

  _RqlTableWithDb table(tableName) => new _RqlTableWithDb(this,tableName);

  _RqlTableDropFromDb tableDrop(tableName) => new _RqlTableDropFromDb(this,tableName);

  operator [](attr) => new _RqlParens(this,attr);


  _listify(item) {
    List l =[];
    l.add(this);
    if(item is Iterable)
      l.addAll(item);
    else
      l.add(item);
    return l;
  }


}

class _RqlQuery {

  final _RqlTerm _term;
  final _Connection _connection;
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
    _protoQuery.token =  new Int64(token);
    _protoQuery.query = _term._buildProtoTerm();
    print(_protoQuery);

    if (options != null) {
      new QueryOptionsBuilder(_protoQuery.globalOptargs).buildProtoOptions(options);
    }
  }
  serialize(){

  }
  _handleProtoResponse(Response protoResponse) {
    if (options != null && options["noReply"]==true) {
      _query.complete();
    } else {
      switch (protoResponse.type) {
        case Response_ResponseType.SUCCESS_ATOM:
          var datumValue = _buildDatumResponseValue(protoResponse.response.first);
          _query.complete(_term.buildQueryResponse(datumValue));
          break;
        case Response_ResponseType.SUCCESS_SEQUENCE:
          var datumValue = [];
          protoResponse.response.forEach((e){
          datumValue.add(_buildDatumResponseValue(e));
          });
          _query.complete(_term.buildQueryResponse(datumValue));
          break;
        case Response_ResponseType.SUCCESS_PARTIAL:
          var datumValue = [];
          protoResponse.response.forEach((e){
          datumValue.add(_buildDatumResponseValue(e));
          });
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

  Future <_RqlQuery> _execute() {
    _updateCurrentDatabase();
    _connection. _log.fine('Query $this');
    _connection._sendQueue.addLast(this);
    _connection._sendBuffer();
    return _query.future;
  }

  _updateCurrentDatabase() {
    if (_connection.db != null && _connection.db.isNotEmpty) {
      var pair = new Query_AssocPair();
      pair.key = "db";
      pair.val = new _RqlDatabase(_connection.db)._buildProtoTerm();
      _protoQuery.globalOptargs.add(pair);
    }
  }

  List<int> get _buffer => _protoQuery.writeToBuffer();
}

