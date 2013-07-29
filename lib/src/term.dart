part of rethinkdb;

///
/// Base Terms
///
abstract class _RqlTerm extends Object with RqlQueryRunner {

  final List<_RqlTerm> _args;
  final RqlOptions _options;
  Term_TermType _termType;


  _RqlTerm(Term_TermType this._termType, [List<_RqlTerm> this._args, RqlOptions this._options]);

  Term _buildProtoTerm() {
    var term = new Term();
    term.type = _termType;
    if (_args != null) {
      _args.forEach((arg) {
        var argTerm = arg._buildProtoTerm();
        term.args.add(argTerm);
      });

      if (_options != null) {
        new TermOptionsBuilder(term.optargs).buildProtoOptions(_options.options);
      }
    }

    return term;
  }
}

abstract class _ResponseTerm<T,S> extends _RqlTerm {
  _ResponseTerm(termType, [List<_RqlTerm> args, RqlOptions options]) :
    super(termType, args, options);

  T buildQueryResponse(S response);
}

abstract class _CreatedResponseTerm extends _ResponseTerm {
  _CreatedResponseTerm(termType, [List<_RqlTerm> args, RqlOptions options]) :
    super(termType, args, options);

  CreatedResponse buildQueryResponse(Map response) => new CreatedResponse(response);
}

abstract class _DroppedResponseTerm extends _ResponseTerm {
  _DroppedResponseTerm(termType, [List<_RqlTerm> args, RqlOptions options]) :
    super(termType, args, options);

  DroppedResponse buildQueryResponse(Map response) => new DroppedResponse(response);
}

abstract class _ListResponseTerm extends _ResponseTerm {
  _ListResponseTerm(termType, [List<_RqlTerm> args, RqlOptions options]) :
    super(termType, args, options);

  List buildQueryResponse(List response) => response;
}

///
/// Management Terms
///
class _RqlDBCreate extends _CreatedResponseTerm {
  _RqlDBCreate(String dbName) : super(Term_TermType.DB_CREATE,  [new _RqlDatumString(dbName)]);
}

class _RqlDBList extends _ListResponseTerm {
  _RqlDBList() : super(Term_TermType.DB_LIST);
}

class _RqlDBDrop extends _DroppedResponseTerm {
  _RqlDBDrop(String dbName) : super(Term_TermType.DB_DROP,  [new _RqlDatumString(dbName)]);
}

class RqlDatabase extends _RqlTerm {
  RqlDatabase(String dbName) : super(Term_TermType.DB,  [new _RqlDatumString(dbName)]);
}

class _RqlTableCreate extends _CreatedResponseTerm {
  _RqlTableCreate(String tableName, [TableCreateOptions options]) :
    super(Term_TermType.TABLE_CREATE,  [new _RqlDatumString(tableName)], options);
}

class _RqlTableDrop extends _DroppedResponseTerm {
  _RqlTableDrop(String tableName) :
    super(Term_TermType.TABLE_DROP,  [new _RqlDatumString(tableName)]);
}

class _RqlTableList extends _ListResponseTerm {
  _RqlTableList() : super(Term_TermType.TABLE_LIST);
}

class RqlTable extends _RqlTerm {
  RqlTable(String tableName, [TableOptions options]) : super(Term_TermType.TABLE, [new _RqlDatumString(tableName)], options);

  RqlIndexCreate indexCreate(String indexName) {
    return new RqlIndexCreate(this, indexName);
  }

  RqlIndexList indexList() {
    return new RqlIndexList(this);
  }

  RqlIndexDrop indexDrop(String indexName) {
    return new RqlIndexDrop(this, indexName);
  }
}

class RqlIndexCreate extends _CreatedResponseTerm {
  RqlIndexCreate(RqlTable table, String indexName) : super(Term_TermType.INDEX_CREATE,  [table, new _RqlDatumString(indexName)]);
}

class RqlIndexList extends _ListResponseTerm {
  RqlIndexList(RqlTable table) : super(Term_TermType.INDEX_LIST,  [table]);
}

class RqlIndexDrop extends _DroppedResponseTerm {
  RqlIndexDrop(RqlTable table, String indexName) : super(Term_TermType.INDEX_DROP,  [table, new _RqlDatumString(indexName)]);
}

