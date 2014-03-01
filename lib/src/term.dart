part of rethinkdb;

abstract class _RqlTerm {

  List<_RqlTerm> _args=[];
  Map _options = {};
  final Term_TermType _termType;


  _RqlTerm(Term_TermType this._termType, [List args, Map options]){
    if(args != null)
      args.forEach((e)=> this._args.add(expr(e)));
    if(options != null)
    options.forEach((k,v){
      this._options[k] = expr(options[k]);
    });
  }

  Future run(_RqlConnection connection, [global_opt_args])
  {
    var query = new _RqlQuery(this,global_opt_args);
    return connection._start(query);
  }

  Term build(){
    Term term = new Term();
    term.type = this._termType;
    if(_args != null)
      _args.forEach((arg) {
        if(arg!=null){
          var argTerm = arg.build();
          term.args.add(argTerm);
        }
      });
      if (_options != null) {
        new TermOptionsBuilder(term.optargs).buildProtoOptions(_options);
      }

    return term;

  }

  noSuchMethod(Invocation invocation) {
    var methodName = invocation.memberName;
    List tmp = invocation.positionalArguments;
          List args = [];
          Map options = {};
          for(var i=0; i < tmp.length; i++){
            if(tmp[i] is Map && i == tmp.length-1)
              options = tmp[i];
            else
              args.add(tmp[i]);
          }

    if(methodName == const Symbol("withFields"))
      return this.withFields(args);
  }

  //Comparison Operators
  _RqlEq eq(val) => new _RqlEq(this,val);

  _RqlNe ne(val) => new _RqlNe(this,val);

  _RqlLt lt(val) => new _RqlLt(this,val);

  _RqlLe le(val) => new _RqlLe(this,val);

  _RqlGt gt(val) => new _RqlGt(this,val);

  _RqlGe ge(val) => new _RqlGe(this,val);

  //Numeric Operators
  _RqlNot not() => new _RqlNot(this);

  _RqlAdd add(number) => new _RqlAdd(this,number);

  _RqlSub sub(number) => new _RqlSub(this,number);

  _RqlMul mul(number) => new _RqlMul(this,number);

  _RqlDiv div(number) => new _RqlDiv(this,number);

  _RqlMod mod(number) => new _RqlMod(this,number);

  _RqlAnd and(b) => new _RqlAnd(this,b);

  _RqlOr or(b) => new _RqlOr(this,b);


  _RqlContains contains(items) => new _RqlContains(_listify(items,true));

  _RqlHasFields hasFields(items) => new _RqlHasFields(_listify(items));

  _RqlWithFields withFields([fields]) => new _RqlWithFields(_listify(fields));

  _RqlKeys keys() => new _RqlKeys(this);

  //Polymorphic object/sequence operations
  _RqlPluck pluck(items) => new _RqlPluck(_listify(items));

  _RqlWithout without(items) => new _RqlWithout(_listify(items));

  _RqlDo reqlDo(arg,expr) => new _RqlDo(this, arg,_funcWrap(expr));

  _RqlDefault defaultTo(value) => new _RqlDefault(this,value);

  _RqlUpdate update(expr,[options]) => new _RqlUpdate(this,_funcWrap(expr),options);

  _RqlReplace replace(expr, [options]) => new _RqlReplace(this,_funcWrap(expr),options);

  _RqlDelete delete([options]) => new _RqlDelete(this,options);

  //Type inspection
  _RqlCoerceTo coerceTo(String type) => new _RqlCoerceTo(this,type);

  _RqlGroupsToArray groupsToArray() => new _RqlGroupsToArray(this);

  _RqlTypeOf typeOf() => new _RqlTypeOf(this);

  _RqlMerge merge(obj) => new _RqlMerge(this,obj);

  _RqlAppend append(val) => new _RqlAppend(this,val);

  _RqlPrepend prepend(val) => new _RqlPrepend(this,val);

  _RqlDifference difference(List ar) => new _RqlDifference(this,ar);

  _RqlSetInsert setInsert(val) => new _RqlSetInsert(this,val);

  _RqlSetUnion setUnion(ar) => new _RqlSetUnion(this,ar);

  _RqlSetIntersection setIntersection(ar) => new _RqlSetIntersection(this,ar);

  _RqlSetDifference setDifference(ar) => new _RqlSetDifference(this,ar);


  _RqlGetField getField(index) => new _RqlGetField(this,index);

  _RqlNth nth(int index) => new _RqlNth(this,index);

  _RqlMatch match(String regex) => new _RqlMatch(this,regex);

  _RqlSplit split(args) => new _RqlSplit(this,args);

  _RqlUpCase upcase() => new _RqlUpCase(this);

  _RqlDownCase downcase() => new _RqlDownCase(this);

  _RqlIsEmpty isEmpty() => new _RqlIsEmpty(this);

  _RqlIndexesOf indexesOf(obj) => new _RqlIndexesOf(this,_funcWrap(obj));

  _RqlSlice slice(int start,[int end]) => new _RqlSlice(this,start,end);

  _RqlSkip skip(int i) => new _RqlSkip(this,i);

  _RqlLimit limit(int i) => new _RqlLimit(this,i);

  _RqlReduce reduce(reductionFunction,[base]) => new _RqlReduce(this,_funcWrap(reductionFunction),base);

  _RqlSum sum(args) => new _RqlSum(this,args);

  _RqlAvg avg(args) => new _RqlAvg(this,args);

  _RqlMin min(args) => new _RqlMin(this,args);

  _RqlMax max(args) => new _RqlMax(this,args);

  _RqlMap map(mappingFunction) => new _RqlMap(this,_funcWrap(mappingFunction));

  _RqlFilter filter(expr,[options]) => new _RqlFilter(this,_funcWrap(expr),options);

  _RqlConcatMap concatMap(mappingFunction) => new _RqlConcatMap(this,_funcWrap(mappingFunction));

  _RqlOrderBy orderBy(attrs){
    if(attrs is List)
      attrs.forEach((ob){
      if(ob is _RqlAsc || ob is _RqlDesc){
        //do nothing
      }
      else
        ob = _funcWrap(ob);
    });

    return new _RqlOrderBy(_listify(attrs));
  }

  _RqlBetween between(lowerKey,upperKey,[options]) => new _RqlBetween(this,lowerKey,upperKey,options);

  _RqlDistinct distinct() => new _RqlDistinct(this);

  _RqlCount count([filter]){
    if(filter == null)
      return new _RqlCount(this);
    return new _RqlCount(this,_funcWrap(filter));
  }

  _RqlUnion union(sequence) => new _RqlUnion(this,sequence);

  _RqlInnerJoin innerJoin(otherSequence, predicate) => new _RqlInnerJoin(this,otherSequence,predicate);

  _RqlOuterJoin outerJoin(otherSequence, predicate) => new _RqlOuterJoin(this,otherSequence,predicate);

  _RqlEqJoin eqJoin(leftAttr,otherTable,[options]) => new _RqlEqJoin(this,leftAttr,otherTable,options);

  _RqlZip zip() => new _RqlZip(this);


  _RqlGroupedMapReduce groupedMapReduce(grouping, mapping, reduction, [base])=>
      new _RqlGroupedMapReduce(this,_funcWrap(grouping),_funcWrap(mapping),_funcWrap(reduction),base);

  _RqlGroupBy groupBy(String attr,reductionObj) => new _RqlGroupBy(this,attr,reductionObj);


  _RqlGroup group(args,[options]) => new _RqlGroup(this,args,options);

  _RqlForEach forEach(write_query) => new _RqlForEach(this,_funcWrap(write_query));

  _RqlInfo info() => new _RqlInfo(this);

  _RqlInsertAt insertAt(index,value) => new _RqlInsertAt(this,index,value);

  _RqlSpliceAt spliceAt(index,ar) => new _RqlSpliceAt(this,index,ar);

  _RqlDeleteAt deleteAt(index,[end]) => new _RqlDeleteAt(this,index,end);

  _RqlChangeAt changeAt(index,value) => new _RqlChangeAt(this,index,value);

  _RqlSample sample(int i) => new _RqlSample(this,i);

  _RqlToISO8601 toISO8601() => new _RqlToISO8601(this);

  _RqlToEpochTime toEpochTime() => new _RqlToEpochTime(this);

  _RqlDuring during(start,end,[options]) => new _RqlDuring(this,start,end,options);

  _RqlDate date() => new _RqlDate(this);

  _RqlTimeOfDay timeOfDay() => new _RqlTimeOfDay(this);

  _RqlTimezone timezone() => new _RqlTimezone(this);

  _RqlYear year() => new _RqlYear(this);

  _RqlMonth month() => new _RqlMonth(this);

  _RqlDay day() => new _RqlDay(this);

  _RqlDayOfWeek dayOfWeek() => new _RqlDayOfWeek(this);

  _RqlDayOfYear dayOfYear() => new _RqlDayOfYear(this);

  _RqlHours hours() => new _RqlHours(this);

  _RqlMinutes minutes() => new _RqlMinutes(this);

  _RqlSeconds seconds() => new _RqlSeconds(this);

  _RqlInTimezone inTimezone(tz) => new _RqlInTimezone(this,tz);




  _listify(item,[needsWrap=false]) {
    if(needsWrap)
      _funcWrap(item);
    List l =[];
    l.add(this);
    if(item is Iterable)
      l.addAll(item);
    else
      l.add(item);
    return l;
  }

  call(attr){
    return new _RqlGetField(this,attr);
  }

}

class _RqlMakeArray extends _RqlTerm {
  _RqlMakeArray(attrs) : super(Term_TermType.MAKE_ARRAY,attrs);

  _RqlDo reqlDo(arg,expression) => new _RqlDo(this, arg,_funcWrap(expression));
}

class _RqlMakeObj extends _RqlTerm {
  _RqlMakeObj(obj) : super(Term_TermType.MAKE_OBJ,[],obj);
}

class _RqlVar extends _RqlTerm {
  _RqlVar(variable) : super(Term_TermType.VAR,[variable]);

  call(arg) => new _RqlGetField(this,arg);
}

class _RqlJs extends _RqlTerm {
  _RqlJs(String js_str, [options]) : super(Term_TermType.JAVASCRIPT, [js_str],options);
}

class _RqlError extends _RqlTerm {
  _RqlError(err, [options]) : super(Term_TermType.ERROR,[err],options);
}

class _RqlDefault extends _RqlTerm {
  _RqlDefault(obj,value) : super(Term_TermType.DEFAULT,[obj,value]);
}

class _RqlImplicitVar extends _RqlTerm {
_RqlImplicitVar():super(Term_TermType.IMPLICIT_VAR);

call(arg) => new _RqlGetField(this,arg);

}

class _RqlEq extends _RqlTerm {
  _RqlEq(comparable,numb) : super(Term_TermType.EQ,[comparable,numb]);
}

class _RqlNe extends _RqlTerm {
  _RqlNe(comparable,numb) : super(Term_TermType.NE,[comparable,numb]);
}

class _RqlLt extends _RqlTerm {
  _RqlLt(comparable,obj) : super(Term_TermType.LT,[comparable,obj]);
}

class _RqlLe extends _RqlTerm {
  _RqlLe(comparable,obj) : super(Term_TermType.LE,[comparable,obj]);
}

class _RqlGt extends _RqlTerm {
  _RqlGt(comparable,obj) : super(Term_TermType.GT,[comparable,obj]);
}

class _RqlGe extends _RqlTerm {
  _RqlGe(comparable,obj) : super(Term_TermType.GE,[comparable,obj]);
}

class _RqlNot extends _RqlTerm {
  _RqlNot(notable) : super(Term_TermType.NOT,[notable]);
}

//Math and Logic
class _RqlAdd extends _RqlTerm {
  _RqlAdd(addable,obj) : super(Term_TermType.ADD,[addable,obj]);
}

class _RqlSub extends _RqlTerm {
  _RqlSub(subbable,obj) : super(Term_TermType.SUB,[subbable,obj]);
}

class _RqlMul extends _RqlTerm {
  _RqlMul(mulable,obj) : super(Term_TermType.MUL,[mulable, obj]);
}

class _RqlDiv extends _RqlTerm {
  _RqlDiv(divisible,obj) : super(Term_TermType.DIV,[divisible, obj]);
}

class _RqlMod extends _RqlTerm {
  _RqlMod(modable,obj) : super(Term_TermType.MOD,[modable,obj]);
}

class _RqlAppend extends _RqlTerm {
  _RqlAppend(ar,val) : super(Term_TermType.APPEND,[ar,val]);
}

class _RqlPrepend extends _RqlTerm {
  _RqlPrepend(ar,val) : super(Term_TermType.PREPEND,[ar,val]);
}

class _RqlDifference extends _RqlTerm {
  _RqlDifference(diffable,ar) : super(Term_TermType.DIFFERENCE,[diffable,ar]);
}

class _RqlSetInsert extends _RqlTerm {
  _RqlSetInsert(ar,val) : super(Term_TermType.SET_INSERT,[ar,val]);
}

class _RqlSetUnion extends _RqlTerm {
  _RqlSetUnion(un,ar) : super(Term_TermType.SET_UNION,[un,ar]);
}

class _RqlSetIntersection extends _RqlTerm {
  _RqlSetIntersection(inter,ar) : super(Term_TermType.SET_INTERSECTION,[inter,ar]);
}

class _RqlSetDifference extends _RqlTerm {
  _RqlSetDifference(diff,ar) : super(Term_TermType.SET_DIFFERENCE,[diff,ar]);
}

class _RqlSlice extends _RqlTerm {
  _RqlSlice(selection,int start,[int end]) : super(Term_TermType.SLICE,[selection,start,end]);
}

class _RqlSkip extends _RqlTerm{
  _RqlSkip(selection,int num) : super(Term_TermType.SKIP,[selection,num]);
}

class _RqlLimit extends _RqlTerm{
  _RqlLimit(selection,int num) : super(Term_TermType.LIMIT,[selection,num]);
}

class _RqlGetField extends _RqlTerm{
  _RqlGetField(obj,field) : super(Term_TermType.GET_FIELD,[obj,field]);
}

class _RqlContains extends _RqlTerm {
  _RqlContains(items) : super(Term_TermType.CONTAINS,[_buildList(items)]);
}

class _RqlHasFields extends _RqlTerm {
  _RqlHasFields(obj,[items]) : super(Term_TermType.HAS_FIELDS,[obj,items]);
}

class _RqlWithFields extends _RqlTerm {
  _RqlWithFields(fields) : super(Term_TermType.WITH_FIELDS,[_buildList(fields)]);
}

class _RqlKeys extends _RqlTerm {
  _RqlKeys(obj) : super(Term_TermType.KEYS,[obj]);
}

class _RqlObject extends _RqlTerm {
  _RqlObject(arg1,arg2) : super(Term_TermType.OBJECT,[arg1,arg2]);
}

class _RqlPluck extends _RqlTerm {
  _RqlPluck(items) : super(Term_TermType.PLUCK,_buildList(items));
}

class _RqlWithout extends _RqlTerm {
  _RqlWithout(items) : super(Term_TermType.WITHOUT,_buildList(items));
}

class _RqlMerge extends _RqlTerm {
  _RqlMerge(sequence,obj) : super(Term_TermType.MERGE,[sequence,obj]);
}

class _RqlBetween extends _RqlTerm {
  _RqlBetween(table,lowerKey,upperKey,[options]) : super(Term_TermType.BETWEEN,[table,lowerKey,upperKey],options);
}

class _RqlDatabase extends _RqlTerm {
   _RqlDatabase(String dbName) : super(Term_TermType.DB,  [dbName]);

   _RqlTableList tableList() => new _RqlTableList(this);

   _RqlTableCreateFromDb tableCreate(String tableName,[Map options]) => new _RqlTableCreateFromDb(this,tableName,options);

   _RqlTableDropFromDb tableDrop(String tableName) => new _RqlTableDropFromDb(this,tableName);

    _RqlTable table(String tableName) => new _RqlTable.fromDb(this,tableName);
}

class _RqlDo extends _RqlTerm {
  _RqlDo(obj, args,expression) : super(Term_TermType.FUNCALL,[obj, args, expression]);
}

class _RqlTable extends _RqlTerm {
  _RqlTable(String tableName, [options]):super(Term_TermType.TABLE,[tableName], options);

  _RqlTable.fromDb(_RqlDatabase db, String tableName,[options]):super(Term_TermType.TABLE,[db,tableName],options);

  _RqlInsert insert(records,[options]) => new _RqlInsert(this,records,options);

  _RqlGet get(key) => new _RqlGet(this,key);

  _RqlGetAll getAll(keys,[Map options]) => new _RqlGetAll(_listify(keys),options);

  _RqlIndexCreate indexCreate(String index,[Function indexFunction]) => new _RqlIndexCreate(this,index,_funcWrap(indexFunction));

  _RqlIndexDrop indexDrop(String index) => new _RqlIndexDrop(this,index);

  _RqlIndexList indexList() => new _RqlIndexList(this);

  _RqlIndexStatus indexStatus([index]) => new _RqlIndexStatus(_listify(index));

  _RqlIndexWait indexWait([index]) =>  new _RqlIndexWait(_listify(index));

  _RqlSync sync() => new _RqlSync(this);

  noSuchMethod(Invocation invocation) {
    var methodName = invocation.memberName;
    List tmp = invocation.positionalArguments;
          List args = [];
          Map options = {};
          for(var i=0; i < tmp.length; i++){
            if(tmp[i] is Map && i == tmp.length-1)
              options = tmp[i];
            else
              args.add(tmp[i]);
          }

    if(methodName == const Symbol("getAll"))
      return this.getAll(args,options);
    if(methodName == const Symbol("indexStatus"))
      return this.indexStatus(args);
    if(methodName == const Symbol("indexWait"))
      return this.indexWait(args);
    if(methodName == const Symbol("withFields"))
      return this.withFields(args);
  }

}

class _RqlGet extends _RqlTerm {
  _RqlGet(table,key) : super(Term_TermType.GET,[table,key]);

  call(attr){
    return new _RqlGetField(this,attr);
  }
}

class _RqlGetAll extends _RqlTerm {
  _RqlGetAll(keys,[options]) : super(Term_TermType.GET_ALL,_buildList(keys),options);

  call(attr){
    return new _RqlGetField(this,attr);
  }
}

class _RqlReduce extends _RqlTerm {
  _RqlReduce(seq,reductionFunction,[base]) : super(Term_TermType.REDUCE,[seq,reductionFunction],{"base":base});
}

class _RqlSum extends _RqlTerm {
  _RqlSum(obj,attr) : super(Term_TermType.SUM,[obj,attr]);
}

class _RqlAvg extends _RqlTerm {
  _RqlAvg(obj,attr) : super(Term_TermType.AVG,[obj,attr]);
}

class _RqlMin extends _RqlTerm {
  _RqlMin(obj,attr) : super(Term_TermType.MIN,[obj,attr]);
}

class _RqlMax extends _RqlTerm {
  _RqlMax(obj,attr) : super(Term_TermType.MAX,[obj,attr]);
}

class _RqlMap extends _RqlTerm {
  _RqlMap(seq,mappingFunction) : super(Term_TermType.MAP,[seq,mappingFunction]);
}

class _RqlFilter extends _RqlTerm {
  _RqlFilter(selection,predicate,[options]) : super(Term_TermType.FILTER,[selection,predicate],options);
}

class _RqlConcatMap extends _RqlTerm {
  _RqlConcatMap(seq,mappingFunction) : super(Term_TermType.CONCATMAP,[seq,mappingFunction]);
}

class _RqlOrderBy extends _RqlTerm {
  _RqlOrderBy(attrs) : super(Term_TermType.ORDERBY,_buildList(attrs));
}

class _RqlDistinct extends _RqlTerm {
  _RqlDistinct(sequence) : super(Term_TermType.DISTINCT,[sequence]);
}

class _RqlCount extends _RqlTerm {
  _RqlCount([seq,filter]) : super(Term_TermType.COUNT,[seq,filter]);
}

class _RqlUnion extends _RqlTerm {
  _RqlUnion(first,second) : super(Term_TermType.UNION,[first,second]);
}

class _RqlNth extends _RqlTerm {
  _RqlNth(selection,int index) : super(Term_TermType.NTH,[selection,index]);
}

class _RqlMatch extends _RqlTerm {
  _RqlMatch(obj,regex) : super(Term_TermType.MATCH,[obj,regex]);
}

class _RqlSplit extends _RqlTerm {
  _RqlSplit(tbl,obj) : super(Term_TermType.SPLIT,[tbl,obj]);
}

class _RqlUpCase extends _RqlTerm {
  _RqlUpCase(obj) : super(Term_TermType.UPCASE,[obj]);
}

class _RqlDownCase extends _RqlTerm {
  _RqlDownCase(obj) : super(Term_TermType.DOWNCASE,[obj]);
}

class _RqlIndexesOf extends _RqlTerm {
  _RqlIndexesOf(seq,index) : super(Term_TermType.INDEXES_OF,[seq,index]);
}

class _RqlIsEmpty extends _RqlTerm {
  _RqlIsEmpty(selection) : super(Term_TermType.IS_EMPTY,[selection]);
}

class _RqlGroup extends _RqlTerm {
  _RqlGroup(obj,group,[options]) : super(Term_TermType.GROUP,[obj,group],options);
}

class _RqlGroupedMapReduce extends _RqlTerm {
  _RqlGroupedMapReduce(seq,grouping,mapping,reduction,base) : super(Term_TermType.GROUPED_MAP_REDUCE,[seq,grouping,mapping,reduction,base]);
}

class _RqlGroupBy extends _RqlTerm {
  _RqlGroupBy(groupable,selector,reductionObject) : super(Term_TermType.GROUPBY,[groupable, selector,reductionObject]);
}

class _RqlInnerJoin extends _RqlTerm {
  _RqlInnerJoin(first,second,predicate) :super(Term_TermType.INNER_JOIN,[first,second,predicate]);
}

class _RqlOuterJoin extends _RqlTerm {
  _RqlOuterJoin(first,second,predicate) : super(Term_TermType.OUTER_JOIN,[first,second,predicate]);
}

class _RqlEqJoin extends _RqlTerm {
  _RqlEqJoin(seq,leftAttr,otherTable,[options]) : super(Term_TermType.EQ_JOIN,[seq,leftAttr,otherTable],options);
}

class _RqlZip extends _RqlTerm {
  _RqlZip(seq) : super(Term_TermType.ZIP,[seq]);
}

class _RqlCoerceTo extends _RqlTerm {
  _RqlCoerceTo(obj,String type) : super(Term_TermType.COERCE_TO,[obj,type]);
}

class _RqlGroupsToArray extends _RqlTerm {
  _RqlGroupsToArray(obj) : super(Term_TermType.GROUPS_TO_ARRAY,[obj]);
}

class _RqlTypeOf extends _RqlTerm {
  _RqlTypeOf(obj) : super(Term_TermType.TYPEOF,[obj]);
}

class _RqlUpdate extends _RqlTerm {
  _RqlUpdate(table,expression,[options]) : super(Term_TermType.UPDATE,[table,expression],options);
}

class _RqlDelete extends _RqlTerm {
  _RqlDelete(selection,[options]) : super(Term_TermType.DELETE,[selection],options);
}

class _RqlReplace extends _RqlTerm {
  _RqlReplace(table,expression,[options]) : super(Term_TermType.REPLACE,[table,expression],options);
}

class _RqlInsert extends _RqlTerm {
  _RqlInsert(table,records,[options]) : super(Term_TermType.INSERT, [table,new _RqlJson( JSON.encode(records))],options);
}

class _RqlDbCreate extends _RqlTerm {
  _RqlDbCreate(dbName,[options]) : super(Term_TermType.DB_CREATE,[dbName,options]);
}

class _RqlDbDrop extends _RqlTerm {
  _RqlDbDrop(dbName,[options]) : super(Term_TermType.DB_DROP,[dbName],options);
}

class _RqlDbList extends _RqlTerm {
  _RqlDbList() : super(Term_TermType.DB_LIST);
}

class _RqlTableCreate extends _RqlTerm {
  _RqlTableCreate(tableName,[options]) : super(Term_TermType.TABLE_CREATE,[tableName],options);
}

class _RqlTableCreateFromDb extends _RqlTerm {
  _RqlTableCreateFromDb(db,tableName,[options]) : super(Term_TermType.TABLE_CREATE,[db,tableName],options);
}

class _RqlTableDrop extends _RqlTerm {
  _RqlTableDrop(tableName,[options]) : super(Term_TermType.TABLE_DROP,[tableName],options);
}

class _RqlTableDropFromDb extends _RqlTerm {
  _RqlTableDropFromDb(db, tableName,[options]) : super(Term_TermType.TABLE_DROP,[db,tableName],options);
}

class _RqlTableList extends _RqlTerm {
  _RqlTableList([obj]) : super(Term_TermType.TABLE_LIST,[obj]);
}

class _RqlIndexCreate extends _RqlTerm {
  _RqlIndexCreate(table,index,[indexFunction,options]) : super(Term_TermType.INDEX_CREATE,[table,index,indexFunction],options);
}

class _RqlIndexDrop extends _RqlTerm {
  _RqlIndexDrop(table,index,[options]) : super(Term_TermType.INDEX_DROP,[table,index],options);
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

class _RqlSync extends _RqlTerm {
  _RqlSync(table) : super(Term_TermType.SYNC, [table]);
}

class _RqlBranch extends _RqlTerm {
  _RqlBranch(predicate, true_branch, false_branch) : super(Term_TermType.BRANCH,[predicate,true_branch,false_branch]);
}

class _RqlOr extends _RqlTerm {
  _RqlOr(orable,obj) : super(Term_TermType.ANY,[orable,obj]);
}

class _RqlAnd extends _RqlTerm {
  _RqlAnd(andable,obj) : super(Term_TermType.ALL,[andable,obj]);
}

class _RqlForEach extends _RqlTerm {
  _RqlForEach(obj,write_query) : super(Term_TermType.FOREACH,[obj,write_query]);
}

class _RqlInfo extends _RqlTerm {
  _RqlInfo(knowable) : super(Term_TermType.INFO,[knowable]);
}

class _RqlInsertAt extends _RqlTerm {
  _RqlInsertAt(ar,index,value) : super(Term_TermType.INSERT_AT,[ar,index,value]);
}

class _RqlSpliceAt extends _RqlTerm {
  _RqlSpliceAt(ar,index,val) : super(Term_TermType.SPLICE_AT,[ar,index,val]);
}

class _RqlDeleteAt extends _RqlTerm {
  _RqlDeleteAt(ar,start,end) : super(Term_TermType.DELETE_AT,[ar,start,end]);
}

class _RqlChangeAt extends _RqlTerm {
  _RqlChangeAt(ar,index,value) : super(Term_TermType.CHANGE_AT,[ar,index,value]);
}

class _RqlSample extends _RqlTerm {
  _RqlSample(selection,int i) : super(Term_TermType.SAMPLE,[selection,i]);
}

class _RqlJson extends _RqlTerm {
  _RqlJson(String jsonString,[options]) : super(Term_TermType.JSON, [jsonString],options);
}

class _RqlToISO8601 extends _RqlTerm {
  _RqlToISO8601(obj) : super(Term_TermType.TO_ISO8601,[obj]);
}

class _RqlDuring extends _RqlTerm {
  _RqlDuring(obj,start,end,[options]) : super(Term_TermType.DURING,[obj,start,end],options);
}

class _RqlDate extends _RqlTerm {
  _RqlDate(obj) : super(Term_TermType.DATE,[obj]);
}

class _RqlTimeOfDay extends _RqlTerm {
  _RqlTimeOfDay(obj) : super(Term_TermType.TIME_OF_DAY,[obj]);
}

class _RqlTimezone extends _RqlTerm {
  _RqlTimezone(zoneable) : super(Term_TermType.TIMEZONE,[zoneable]);
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

class _RqlTime extends _RqlTerm {
  _RqlTime(year, month, day, timezone, [hour, minute, second]) :
    super(Term_TermType.TIME,[year,month,day,hour,minute,second,timezone]);

  _RqlTime.nativeTime(DateTime nativeTime):super(Term_TermType.TIME, [nativeTime]);
}

class _RqlISO8601 extends _RqlTerm {
  _RqlISO8601(stringTime,[default_time_zone="Z"]) : super(Term_TermType.ISO8601,[stringTime],{"default_timezone":default_time_zone});
}

class _RqlEpochTime extends _RqlTerm {
  _RqlEpochTime(epochTime) : super(Term_TermType.EPOCH_TIME,[epochTime]);
}

class _RqlNow extends _RqlTerm {
  _RqlNow() : super(Term_TermType.NOW);
}

class _RqlInTimezone extends _RqlTerm {
  _RqlInTimezone(zoneable,tz) : super(Term_TermType.IN_TIMEZONE,[zoneable,tz]);
}

class _RqlToEpochTime extends _RqlTerm {
  _RqlToEpochTime(obj) : super(Term_TermType.TO_EPOCH_TIME,[obj]);
}

_funcWrap(val){
  val = expr(val);
  // Scan for IMPLICIT_VAR or JS
  List argList = [];
  List optList = [];
  ivar_scan(node){
    if(node is _RqlTerm == false)
      return false;
    if(node is _RqlImplicitVar)
      return true;
    node._args.forEach((arg){
      argList.add(ivar_scan(arg));
    });
    if(argList.any((bool i) => i == true))
      return true;
    node._options.forEach((k,arg){
      optList.add(ivar_scan(arg));
    });
    if(optList.any((bool i) => i == true))
      return true;
    return false;
  }

  if(ivar_scan(val))
    return new _RqlFunction((x)=>val);
  return val;
}

class _RqlFunction extends _RqlTerm {
  var fun;
  static var nextId = 1;
  _RqlFunction(fun) : super(Term_TermType.FUNC){
    ClosureMirror closure = reflect(fun);
    var x = closure.function.parameters.length;
    List vrs =[];
    List vrids = [];

    for(var i=0;i<x;i++){
      vrs.add(new _RqlVar(_RqlFunction.nextId));
      vrids.add(_RqlFunction.nextId);
      _RqlFunction.nextId++;
    }

    this._args =  [new _RqlMakeArray(vrids),expr(Function.apply(fun, vrs))];

  }

}

class _RqlAsc extends _RqlTerm {
  _RqlAsc(attr) : super(Term_TermType.ASC,[attr]);
}

class _RqlDesc extends _RqlTerm {
  _RqlDesc(attr) : super(Term_TermType.DESC,[attr]);
}

class _RqlLiteral extends _RqlTerm {
  _RqlLiteral(attr) : super(Term_TermType.LITERAL,[attr]);
}


_RqlTerm expr(val)
{
  if(val is _RqlTerm)
    return val;
  else if(val is DateTime)
    return new _RqlISO8601(val.toString(),_fmtTz(val.timeZoneOffset.toString()));
  else if(val is List) {
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
  else if(val is Function)
    return new _RqlFunction(val);
  else if(val is bool)
    return new _RqlDatumBool(val);
  else if(val is num)
    return new _RqlDatumNum(val);
  else if(val is String)
    return new _RqlDatumString(val);
  else {
    return val;
  }

}


String _fmtTz(tz){
  StringBuffer sb = new StringBuffer();
  sb.write(tz[0]);
  if(tz[2] == ":")
    sb.write("0");
  sb.write(tz.substring(1,5));
  return sb.toString();
}

_buildList(val) {
  List copy = [];
  val.forEach((element)=>copy.add(element));
  return copy;
}




_reql_type_time_to_datetime(obj){
  //TODO convert rql time to native DateTime
}