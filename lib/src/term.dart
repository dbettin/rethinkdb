part of rethinkdb;

///
/// Base Terms
///
abstract class _RqlTerm extends RqlQueryRunner {

  final List<_RqlTerm> _args;
  final Map _options;
  final Map _optargs;
  Term_TermType _termType;


  _RqlTerm(Term_TermType this._termType, [List<_RqlTerm> this._args, Map this._options, Map this._optargs]);

  Term _buildProtoTerm() {
    var term = new Term();
    term.type = _termType;
    if (_args != null) {
      _args.forEach((arg) {
        if(arg!=null){
          var argTerm = arg._buildProtoTerm();
          term.args.add(argTerm);
        }
      });

      if (_options != null) {
        new TermOptionsBuilder(term.optargs).buildProtoOptions(_options);
      }
      if(_optargs != null) {
        new TermOptionsBuilder(term.optargs).buildProtoOptions(_optargs);
      }
    }

    return term;
  }

  buildQueryResponse(response)=>response;

}

//Database operations
class _RqlDbCreate extends _RqlTerm {
  _RqlDbCreate(dbName,[options]) : super(Term_TermType.DB_CREATE,[expr(dbName),options]);
}

class _RqlDbDrop extends _RqlTerm {
  _RqlDbDrop(dbName,[options]) : super(Term_TermType.DB_DROP,[expr(dbName)],options);
}

class _RqlDbList extends _RqlTerm {
  _RqlDbList() : super(Term_TermType.DB_LIST);
}


//Table operations
class _RqlTableCreate extends _RqlTerm {
  _RqlTableCreate(tableName,[options]) : super(Term_TermType.TABLE_CREATE,[expr(tableName)],options);
}

class _RqlTableCreateFromDb extends _RqlTerm {
  _RqlTableCreateFromDb(db,tableName,[options]) : super(Term_TermType.TABLE_CREATE,[db,expr(tableName)],options);
}

class _RqlTableDrop extends _RqlTerm {
  _RqlTableDrop(tableName,[options]) : super(Term_TermType.TABLE_DROP,[expr(tableName)],options);
}

class _RqlTableDropFromDb extends _RqlTerm {
  _RqlTableDropFromDb(db, tableName,[options]) : super(Term_TermType.TABLE_DROP,[db,expr(tableName)],options);
}

class _RqlTableList extends _RqlTerm {
  _RqlTableList([obj]) : super(Term_TermType.TABLE_LIST,[obj]);
}

class _RqlIndexCreate extends _RqlTerm {
  _RqlIndexCreate(table,index,[indexFunction,options]) : super(Term_TermType.INDEX_CREATE,[table,expr(index),expr(indexFunction)],options);
}

class _RqlIndexDrop extends _RqlTerm {
  _RqlIndexDrop(table,index,[options]) : super(Term_TermType.INDEX_DROP,[table,expr(index)],options);
}


class _RqlIndexList extends _RqlTerm {
  _RqlIndexList(table) : super(Term_TermType.INDEX_LIST,[table]);
}

class _RqlIndexStatus extends _RqlTerm {
  _RqlIndexStatus(indexList) : super(Term_TermType.INDEX_STATUS,_buildList(indexList));
}

class _RqlIndexWait extends _RqlTerm {
  _RqlIndexWait(indexList) : super(Term_TermType.INDEX_WAIT, _buildList(indexList));
}

//Writing Data
class _RqlInsert extends _RqlTerm {
  _RqlInsert(table,records,[options]) : super(Term_TermType.INSERT, [table,new _RqlJson( JSON.encode(records))],options);
}


class _RqlUpdate extends _RqlTerm {
  _RqlUpdate(table,exp,[options]) : super(Term_TermType.UPDATE,[table,expr(exp)],options);
}

class _RqlReplace extends _RqlTerm {
  _RqlReplace(table,exp,[options]) : super(Term_TermType.REPLACE,[table,expr(exp)],options);
}

class _RqlDelete extends _RqlTerm {
  _RqlDelete(selection,[options]) : super(Term_TermType.DELETE,[selection],options);
}

class _RqlSync extends _RqlTerm {
  _RqlSync(table) : super(Term_TermType.SYNC, [table]);
}

//Selecting Data
class _RqlDatabase extends _RqlTerm {
   _RqlDatabase(String dbName) : super(Term_TermType.DB,  [expr(dbName)]);
}

class _RqlTable extends _RqlTerm {
  _RqlTable(tbl_name, [options]):super(Term_TermType.TABLE,[expr(tbl_name)], options);
}

class _RqlTableWithDb extends _RqlTerm {
  _RqlTableWithDb(db,tableName, [options]):super(Term_TermType.TABLE,[db,expr(tableName)],options);
}

class _RqlGet extends _RqlTerm {
  _RqlGet(table,key) : super(Term_TermType.GET,[table,expr(key)]);

  call(attr){
    return new _RqlParens(this,attr);
  }
}

class _RqlGetAll extends _RqlTerm {
  _RqlGetAll(keys,[options]) : super(Term_TermType.GET_ALL,_buildList(keys),options);
}

class _RqlBetween extends _RqlTerm {
  _RqlBetween(table,lowerKey,upperKey,[options]) : super(Term_TermType.BETWEEN,[table,expr(lowerKey),expr(upperKey)],options);
}

class _RqlFilter extends _RqlTerm {
  _RqlFilter(selection,predicate,[options]) : super(Term_TermType.FILTER,[selection,expr(predicate)],options);
}

class _RqlAsc extends _RqlTerm {
  _RqlAsc(attr) : super(Term_TermType.ASC,[expr(attr)]);
}

class _RqlDesc extends _RqlTerm {
  _RqlDesc(attr) : super(Term_TermType.DESC,[expr(attr)]);
}

//Joins
class _RqlInnerJoin extends _RqlTerm {
  _RqlInnerJoin(first,second,predicate) :super(Term_TermType.INNER_JOIN,[first,expr(second),expr(predicate)]);
}

class _RqlOuterJoin extends _RqlTerm {
  _RqlOuterJoin(first,second,predicate) : super(Term_TermType.OUTER_JOIN,[first,expr(second),expr(predicate)]);
}

class _RqlEqJoin extends _RqlTerm {
  _RqlEqJoin(seq,leftAttr,otherTable,[options]) : super(Term_TermType.EQ_JOIN,[seq,expr(leftAttr),expr(otherTable)],options);
}

class _RqlZip extends _RqlTerm {
  _RqlZip(seq) : super(Term_TermType.ZIP,[seq]);
}

//Transformations
class _RqlMap extends _RqlTerm {
  _RqlMap(seq,mappingFunction) : super(Term_TermType.MAP,[seq,expr(mappingFunction)]);
}

class _RqlWithFields extends _RqlTerm {
  _RqlWithFields(fields) : super(Term_TermType.WITH_FIELDS,[_buildList(fields)]);
}

class _RqlConcatMap extends _RqlTerm {
  _RqlConcatMap(seq,mappingFunction) : super(Term_TermType.CONCATMAP,[seq,expr(mappingFunction)]);
}

class _RqlOrderBy extends _RqlTerm {
  _RqlOrderBy(attrs) : super(Term_TermType.ORDERBY,_buildList(attrs));
}

class _RqlSkip extends _RqlTerm{
  _RqlSkip(selection,int num) : super(Term_TermType.SKIP,[selection,expr(num)]);
}

class _RqlLimit extends _RqlTerm{
  _RqlLimit(selection,int num) : super(Term_TermType.LIMIT,[selection,expr(num)]);
}

class _RqlSlice extends _RqlTerm {
  _RqlSlice(selection,int start,[int end]) : super(Term_TermType.SLICE,[selection,expr(start),expr(end)]);
}

class _RqlNth extends _RqlTerm {
  _RqlNth(selection,int index) : super(Term_TermType.NTH,[selection,expr(index)]);
}

class _RqlIndexesOf extends _RqlTerm {
  _RqlIndexesOf(seq,index) : super(Term_TermType.INDEXES_OF,[seq,expr(index)]);
}

class _RqlIsEmpty extends _RqlTerm {
  _RqlIsEmpty(selection) : super(Term_TermType.IS_EMPTY,[selection]);
}

class _RqlUnion extends _RqlTerm {
  _RqlUnion(first,second) : super(Term_TermType.UNION,[first,second]);
}

class _RqlSample extends _RqlTerm {
  _RqlSample(selection,int i) : super(Term_TermType.SAMPLE,[selection,expr(i)]);
}

//Aggregation
class _RqlReduce extends _RqlTerm {
  _RqlReduce(seq,reductionFunction,[base]) : super(Term_TermType.REDUCE,[seq,expr(reductionFunction)],{"base":base});
}

class _RqlCount extends _RqlTerm {
  _RqlCount([seq]) : super(Term_TermType.COUNT,[seq]);
}

class _RqlDistinct extends _RqlTerm {
  _RqlDistinct(sequence) : super(Term_TermType.DISTINCT,[sequence]);
}

class _RqlGroupedMapReduce extends _RqlTerm {
  _RqlGroupedMapReduce(seq,grouping,mapping,reduction,base) : super(Term_TermType.GROUPED_MAP_REDUCE,[seq,expr(grouping),expr(mapping),expr(reduction),expr(base)]);
}

class _RqlGroupBy extends _RqlTerm {
  _RqlGroupBy(groupable,selector,reductionObject) : super(Term_TermType.GROUPBY,[groupable, expr(selector),expr(reductionObject)]);
}

class _RqlContains extends _RqlTerm {
  _RqlContains(items) : super(Term_TermType.CONTAINS,[_buildList(items)]);
}

//Aggregators
class _RqlSum extends _RqlTerm {
  _RqlSum(attr) : super(Term_TermType.MAKE_OBJ,[null],null,{"SUM":expr(attr)});
}

class _RqlAvg extends _RqlTerm {
  _RqlAvg(attr) : super(Term_TermType.MAKE_OBJ,[null],null,{"AVG":expr(attr)});
}

//Document Manipulation
class _RqlPluck extends _RqlTerm {
  _RqlPluck(items) : super(Term_TermType.PLUCK,_buildList(items));
}

class _RqlWithout extends _RqlTerm {
  _RqlWithout(items) : super(Term_TermType.WITHOUT,_buildList(items));
}

class _RqlMerge extends _RqlTerm {
  _RqlMerge(sequence,obj) : super(Term_TermType.MERGE,[sequence,expr(obj)]);
}

class _RqlAppend extends _RqlTerm {
  _RqlAppend(ar,val) : super(Term_TermType.APPEND,[ar,expr(val)]);
}

class _RqlPrepend extends _RqlTerm {
  _RqlPrepend(ar,val) : super(Term_TermType.PREPEND,[ar,expr(val)]);
}

class _RqlDifference extends _RqlTerm {
  _RqlDifference(diffable,ar) : super(Term_TermType.DIFFERENCE,[diffable,expr(ar)]);
}

class _RqlSetInsert extends _RqlTerm {
  _RqlSetInsert(ar,val) : super(Term_TermType.SET_INSERT,[ar,expr(val)]);
}

class _RqlSetUnion extends _RqlTerm {
  _RqlSetUnion(un,ar) : super(Term_TermType.SET_UNION,[un,expr(ar)]);
}

class _RqlSetIntersection extends _RqlTerm {
  _RqlSetIntersection(inter,ar) : super(Term_TermType.SET_INTERSECTION,[inter,expr(ar)]);
}

class _RqlSetDifference extends _RqlTerm {
  _RqlSetDifference(diff,ar) : super(Term_TermType.SET_DIFFERENCE,[diff,expr(ar)]);
}

class _RqlParens extends _RqlTerm {
  _RqlParens(obj,attr) : super(Term_TermType.GET_FIELD,[obj,expr(attr)]);

}

class _RqlHasFields extends _RqlTerm {
  _RqlHasFields(obj,[item1,item2,item3,item4,item5,item6,item7,item8,item9,item10]) : super(Term_TermType.HAS_FIELDS,[obj,expr(item1),expr(item2),expr(item3),expr(item4),expr(item5),expr(item6),expr(item7),expr(item8),expr(item9),expr(item10)]);
}

class _RqlInsertAt extends _RqlTerm {
  _RqlInsertAt(ar,index,value) : super(Term_TermType.INSERT_AT,[ar,expr(index),expr(value)]);
}

class _RqlSpliceAt extends _RqlTerm {
  _RqlSpliceAt(ar,index,val) : super(Term_TermType.SPLICE_AT,[ar,expr(index),expr(val)]);
}

class _RqlDeleteAt extends _RqlTerm {
  _RqlDeleteAt(ar,start,end) : super(Term_TermType.DELETE_AT,[ar,expr(start),expr(end)]);
}

class _RqlChangeAt extends _RqlTerm {
  _RqlChangeAt(ar,index,value) : super(Term_TermType.CHANGE_AT,[ar,expr(index),expr(value)]);
}

class _RqlKeys extends _RqlTerm {
  _RqlKeys(obj) : super(Term_TermType.KEYS,[obj]);
}

//String Manipulation
class _RqlMatch extends _RqlTerm {
  _RqlMatch(obj,regex) : super(Term_TermType.MATCH,[obj,expr(regex)]);
}

//Math and Logic
class _RqlAdd extends _RqlTerm {
  _RqlAdd(addable,obj) : super(Term_TermType.ADD,[addable,expr(obj)]);
}

class _RqlSub extends _RqlTerm {
  _RqlSub(subbable,obj) : super(Term_TermType.SUB,[subbable,expr(obj)]);
}

class _RqlMul extends _RqlTerm {
  _RqlMul(mulable,obj) : super(Term_TermType.MUL,[mulable, expr(obj)]);
}

class _RqlDiv extends _RqlTerm {
  _RqlDiv(divisible,obj) : super(Term_TermType.DIV,[divisible, expr(obj)]);
}

class _RqlMod extends _RqlTerm {
  _RqlMod(modable,obj) : super(Term_TermType.MOD,[modable,expr(obj)]);
}

class _RqlAnd extends _RqlTerm {
  _RqlAnd(andable,obj) : super(Term_TermType.ALL,[andable,expr(obj)]);
}

class _RqlOr extends _RqlTerm {
  _RqlOr(orable,obj) : super(Term_TermType.ANY,[orable,expr(obj)]);
}

class _RqlEq extends _RqlTerm {
  _RqlEq(comparable,numb) : super(Term_TermType.EQ,[comparable,expr(numb)]);
}

class _RqlNe extends _RqlTerm {
  _RqlNe(comparable,numb) : super(Term_TermType.NE,[comparable,expr(numb)]);
}

class _RqlGt extends _RqlTerm {
  _RqlGt(comparable,obj) : super(Term_TermType.GT,[comparable,expr(obj)]);
}

class _RqlGe extends _RqlTerm {
  _RqlGe(comparable,obj) : super(Term_TermType.GE,[comparable,expr(obj)]);
}

class _RqlLt extends _RqlTerm {
  _RqlLt(comparable,obj) : super(Term_TermType.LT,[comparable,expr(obj)]);
}

class _RqlLe extends _RqlTerm {
  _RqlLe(comparable,obj) : super(Term_TermType.LE,[comparable,expr(obj)]);
}

class _RqlNot extends _RqlTerm {
  _RqlNot(notable) : super(Term_TermType.NOT,[notable]);
}

//Dates and Times
class _RqlNow extends _RqlTerm {
  _RqlNow() : super(Term_TermType.NOW);
}

class _RqlTime extends _RqlTerm {
  _RqlTime(year, month, day, timezone, [hour, minute, second]) : super(Term_TermType.TIME,[expr(year),expr(month),expr(day),expr(hour),expr(minute),expr(second),expr(timezone)]);
}

class _RqlEpochTime extends _RqlTerm {
  _RqlEpochTime(epochTime) : super(Term_TermType.EPOCH_TIME,[expr(epochTime)]);
}

class _RqlISO8601 extends _RqlTerm {
  _RqlISO8601(stringTime,default_time_zone) : super(Term_TermType.ISO8601,[expr(stringTime)],{"default_time_zone":expr(default_time_zone)});
}

class _RqlInTimezone extends _RqlTerm {
  _RqlInTimezone(zoneable,tz) : super(Term_TermType.IN_TIMEZONE,[zoneable,expr(tz)]);
}

class _RqlTimezone extends _RqlTerm {
  _RqlTimezone(zoneable) : super(Term_TermType.TIMEZONE,[zoneable]);
}

class _RqlDuring extends _RqlTerm {
  _RqlDuring(obj,start,end,[options]) : super(Term_TermType.DURING,[obj,expr(start),expr(end)],options);
}

class _RqlDate extends _RqlTerm {
  _RqlDate(obj) : super(Term_TermType.DATE,[obj]);
}

class _RqlTimeOfDay extends _RqlTerm {
  _RqlTimeOfDay(obj) : super(Term_TermType.TIME_OF_DAY,[obj]);
}

class _RqlYear extends _RqlTerm {
  _RqlYear(obj) : super(Term_TermType.YEAR,[obj]);
}

class _RqlMonth extends _RqlTerm {
  _RqlMonth(obj) : super(Term_TermType.MONTH,[obj]);
}

class _RqlDay extends _RqlTerm {
  _RqlDay(obj) : super(Term_TermType.DAY,[obj]);
}

class _RqlDayOfWeek extends _RqlTerm {
  _RqlDayOfWeek(obj) : super(Term_TermType.DAY_OF_WEEK,[obj]);
}

class _RqlDayOfYear extends _RqlTerm {
  _RqlDayOfYear(obj) : super(Term_TermType.DAY_OF_YEAR,[obj]);
}

class _RqlHours extends _RqlTerm {
  _RqlHours(obj) : super(Term_TermType.HOURS,[obj]);
}

class _RqlMinutes extends _RqlTerm {
  _RqlMinutes(obj) : super(Term_TermType.MINUTES,[obj]);
}

class _RqlSeconds extends _RqlTerm {
  _RqlSeconds(obj) : super(Term_TermType.SECONDS,[obj]);
}

class _RqlToISO8601 extends _RqlTerm {
  _RqlToISO8601(obj) : super(Term_TermType.TO_ISO8601,[obj]);
}

class _RqlToEpochTime extends _RqlTerm {
  _RqlToEpochTime(obj) : super(Term_TermType.TO_EPOCH_TIME,[obj]);
}

//Control Structures
class _RqlDo extends _RqlTerm {
  _RqlDo(args) : super(Term_TermType.FUNCALL,[expr(args)]);
}

class _RqlBranch extends _RqlTerm {
  _RqlBranch(predicate, true_branch, false_branch) : super(Term_TermType.BRANCH,[expr(predicate),expr(true_branch),expr(false_branch)]);
}

class _RqlForEach extends _RqlTerm {
  _RqlForEach(obj,write_query) : super(Term_TermType.FOREACH,[obj,expr(write_query)]);
}

class _RqlError extends _RqlTerm {
  _RqlError(err, [options,optargs]) : super(Term_TermType.ERROR,[expr(err)],options,optargs);
}

class _RqlDefault extends _RqlTerm {
  _RqlDefault(obj,value) : super(Term_TermType.DEFAULT,[obj,expr(value)]);
}

expr(val)
{
  if(val is List) {
    List copy = [];
    val.forEach((element)=>copy.add(expr(element)));
    return new _RqlMakeArray(copy);
  }
  else if(val is Map) {
    Map obj = {};
    val.forEach((k,v){
      obj[k] = expr(v);
    });
    return new _RqlMakeObj(obj);
  }
  else if(val is bool)
    return new _RqlDatumBool(val);
  else if(val is num)
    return new _RqlDatumNum(val);
  else if(val is String)
    return new _RqlDatumString(val);
  else if(val is Function && val is _RqlVar == false)
    return new _RqlFunction(val);
  else {
    return val;
  }

}

class _RqlJs extends _RqlTerm {
  _RqlJs(String js_str, [options,optargs]) : super(Term_TermType.JAVASCRIPT, [expr(js_str)],options,optargs);
}

class _RqlCoerceTo extends _RqlTerm {
  _RqlCoerceTo(obj,String type) : super(Term_TermType.COERCE_TO,[obj,expr(type)]);
}

class _RqlTypeOf extends _RqlTerm {
  _RqlTypeOf(obj) : super(Term_TermType.TYPEOF,[obj]);
}

class _RqlInfo extends _RqlTerm {
  _RqlInfo(knowable) : super(Term_TermType.INFO,[expr(knowable)]);
}

class _RqlJson extends _RqlTerm {
  _RqlJson(String jsonString,[options, optargs]) : super(Term_TermType.JSON, [expr(jsonString)],options,optargs);
}

class _RqlImplicitVar extends _RqlTerm {
_RqlImplicitVar():super(Term_TermType.IMPLICIT_VAR,[]);

call(arg){
  return new _RqlParens(this,arg);
}
}


//Utils
class _RqlMakeObj extends _RqlTerm {
  _RqlMakeObj(obj) : super(Term_TermType.MAKE_OBJ,[],null,obj);
}
class _RqlMakeArray extends _RqlTerm {
  _RqlMakeArray(attrs) : super(Term_TermType.MAKE_ARRAY,attrs);
}

class _RqlVar extends _RqlTerm {
  _RqlVar(variable) : super(Term_TermType.VAR,[expr(variable)]);

  call(arg) => new _RqlParens(this,arg);
}

class _RqlFunction extends _RqlTerm {
  var fun;
  static var nextId = 1;
  _RqlFunction(fun) : super(Term_TermType.FUNC,getArgLength(fun));

  static getArgLength(fun){
    MethodMirror methodMirror = reflect(fun).function;
    var x = methodMirror.parameters.length;
    List vrs =[];
    List vrids = [];

    for(var i=0;i<x;i++){
      vrs.add(new _RqlVar(_RqlFunction.nextId));
      vrids.add(_RqlFunction.nextId);
      nextId++;
    }

    return [expr(vrids),expr(Function.apply(fun, vrs))];

  }

}

_buildList(val) {
  List copy = [];
  val.forEach((element)=>copy.add(expr(element)));
  return copy;
}

_funcWrap(val){
    // Scan for IMPLICIT_VAR
    if(_needsWrap(val._args))
      return new _RqlFunction((x)=>val);
    else
      return val;
}

_needsWrap(valAr)  {
  if(valAr != null || valAr is _RqlFunction)
  for(var i=0;i<valAr.length;i++)
  {
    var p = _needsWrap(valAr[i]._args);
    if(p == true)
      return true;
    if(valAr[i] is _RqlImplicitVar)
      return true;
  }
  return false;
}