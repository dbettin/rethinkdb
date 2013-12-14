library rethinkdb;

import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'src/generated/ql2.pb.dart';
import 'dart:convert';
import 'dart:mirrors';
part 'src/connection.dart';
part 'src/exceptions.dart';
part 'src/response.dart';
part 'src/term.dart';
part 'src/datum.dart';
part 'src/query.dart';
part 'src/options.dart';
part 'src/RqlMessageHandler.dart';
part 'src/config.dart';



// Connection Management
Future<_Connection> connect({String db, String host: _Connection.DEFAULT_HOST, num port: _Connection.DEFAULT_PORT,
  String authKey: _Connection.DEFAULT_AUTH_KEY}) =>  new _Connection().connect(db,host,port,authKey);


_RqlDatabase db(String dbName,[Map options]) => new _RqlDatabase(dbName);
_RqlDbCreate dbCreate(String dbName) => new _RqlDbCreate(dbName);
_RqlDbDrop   dbDrop(String dbName) => new _RqlDbDrop(dbName);
_RqlDbList   dbList() => new _RqlDbList();

_RqlTable table(String tableName,[Map options]) => new _RqlTable(tableName,options);
_RqlTableCreate tableCreate(String tableName,[Map options]) => new _RqlTableCreate(tableName,options);
_RqlTableList tableList() => new _RqlTableList();
_RqlTableDrop tableDrop(String tableName,[Map options]) => new _RqlTableDrop(tableName,options);

_RqlAsc asc(String attr) => new _RqlAsc(attr);
_RqlDesc desc(String attr) => new _RqlDesc(attr);
_RqlTime time(int year,int month,int day,String timezone,[int hour,int minute,num second]) => new _RqlTime(year, month, day,timezone,hour, minute, second);
_RqlISO8601 ISO8601(stringTime,[default_time_zone]) => new _RqlISO8601(stringTime,default_time_zone);
_RqlEpochTime epochTime(eptime) => new _RqlEpochTime(eptime);
_RqlNow now() => new _RqlNow();

_RqlDo reqlDo(arg,[args,expr]) => new _RqlDo([arg,args,expr]);
_RqlBranch branch(test,trueBranch,falseBranch) => new _RqlBranch(test,trueBranch,falseBranch);
_RqlError error(String message) => new _RqlError(message);
_RqlJs js(String js) => new _RqlJs(js);
_RqlJson json(String json) => new _RqlJson(json);

Map count = {"COUNT":true};
Map sum(String attr) => {'SUM':attr};
Map avg(String attr) => {"AVG": attr};
_RqlImplicitVar row(String rowName) => new _RqlImplicitVar();



