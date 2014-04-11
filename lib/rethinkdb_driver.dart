library rethinkdb;

import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'dart:typed_data';
import 'src/generated/ql2.pb.dart';
import 'dart:mirrors';
part 'src/connection.dart';
part 'src/exceptions.dart';
part 'src/term.dart';
part 'src/datum.dart';
part 'src/query.dart';
part 'src/options.dart';

class Rethinkdb{
// Connection Management
/**
 * Create a new connection to the database server. Accepts the following options:
 * host: the host to connect to (default localhost).
 * port: the port to connect on (default 28015).
 * db: the default database (defaults to test).
 * authKey: the authentication key (default none).
 */
Future<_RqlConnection> connect({String db, String host: _RqlConnection.DEFAULT_HOST, num port: _RqlConnection.DEFAULT_PORT,
  String authKey: _RqlConnection.DEFAULT_AUTH_KEY}) =>  new _RqlConnection().connect(db,host,port,authKey);

/**
 *Reference a database.This command can be chained with other commands to do further processing on the data.
 */
 _RqlDatabase db(String dbName) => new _RqlDatabase(dbName);

/**
 * Create a database. A RethinkDB database is a collection of tables, similar to relational databases.
 * If successful, the operation returns an object: {created: 1}. If a database with the same name already exists the operation throws RqlRuntimeError.
 * Note: that you can only use alphanumeric characters and underscores for the database name.
 */
_RqlDbCreate dbCreate(String dbName) => new _RqlDbCreate(dbName);

/**
 * Drop a database. The database, all its tables, and corresponding data will be deleted.
 * If successful, the operation returns the object {dropped: 1}.
 * If the specified database doesn't exist a RqlRuntimeError is thrown.
*/
_RqlDbDrop dbDrop(String dbName) => new _RqlDbDrop(dbName);

/**
 * List all database names in the system. The result is a list of strings.
 */
_RqlDbList dbList() => new _RqlDbList();


/**
 * Select all documents in a table. This command can be chained with other commands to do further processing on the data.
 */
 _RqlTable table(String tableName,[Map options]) => new _RqlTable(tableName,options);
/**
 * Create a table. A RethinkDB table is a collection of JSON documents.
 * If successful, the operation returns an object: {created: 1}. If a table with the same name already exists, the operation throws RqlRuntimeError.
 * Note: that you can only use alphanumeric characters and underscores for the table name.
 */
_RqlTableCreate tableCreate(String tableName,[Map options]) => new _RqlTableCreate(tableName,options);

/**
 * List all table names in a database. The result is a list of strings.
 */
_RqlTableList tableList() => new _RqlTableList();

/**
 * Drop a table. The table and all its data will be deleted.
 */
_RqlTableDrop tableDrop(String tableName,[Map options]) => new _RqlTableDrop(tableName,options);

/**
 * Specify ascending order on an attribute
 */
_RqlAsc asc(String attr) => new _RqlAsc(attr);

/**
 * Specify descending order on an attribute
 */
_RqlDesc desc(String attr) => new _RqlDesc(attr);

/**
 * Create a time object for a specific time.
 */
_RqlTime time(int year,int month,int day,String timezone,[int hour,int minute,num second]) => new _RqlTime(year, month, day,timezone,hour, minute, second);

//TODO fix nativeTime
/**
 * Create a time object from a Dart DateTime object.
 * Not working yet
 */
_RqlTime nativeTime(DateTime time) => new _RqlTime.nativeTime(time);

/**
 * Create a time object based on an iso8601 date-time string (e.g. '2013-01-01T01:01:01+00:00').
 * We support all valid ISO 8601 formats except for week dates.
 * If you pass an ISO 8601 date-time without a time zone, you must specify the time zone with the optarg default_timezone.
 *
 */
_RqlISO8601 ISO8601(String stringTime,[default_time_zone="Z"]) => new _RqlISO8601(stringTime,default_time_zone);

/**
 * Create a time object based on seconds since epoch.
 *  The first argument is a double and will be rounded to three decimal places (millisecond-precision).
 */
_RqlEpochTime epochTime(int eptime) => new _RqlEpochTime(eptime);

/**
 * Return a time object representing the current time in UTC.
 *  The command now() is computed once when the server receives the query, so multiple instances of r.now() will always return the same time inside a query.
 */
_RqlNow now() => new _RqlNow();

/**
 * Evaluate the expr in the context of one or more value bindings.
 * The type of the result is the type of the value returned from expr.
 */
_RqlDo rqlDo(arg,[expr]) => new _RqlDo(arg,expr);

/**
 * If the test expression returns false or null, the [falseBranch] will be executed.
 * In the other cases, the [trueBranch] is the one that will be evaluated.
 */
_RqlBranch branch(test,trueBranch,falseBranch) => new _RqlBranch(test,trueBranch,falseBranch);

/**
 * Throw a runtime error. If called with no arguments inside the second argument to default, re-throw the current error.
 */
_RqlError error(String message) => new _RqlError(message);

/**
 * Create a javascript expression.
 */
_RqlJs js(String js) => new _RqlJs(js);

/**
 * Parse a JSON string on the server.
 */
_RqlJson json(String json) => new _RqlJson(json);

/**
 * Count the total size of the group.
 */
Map count = {"COUNT":true};

/**
 * Compute the sum of the given field in the group.
 */
Map sum(String attr) => {'SUM':attr};

/**
 * Compute the average value of the given attribute for the group.
 */
Map avg(String attr) => {"AVG": attr};

/**
 * Returns the currently visited document.
 */
_RqlGetField row(String rowName) => new _RqlGetField(new _RqlImplicitVar(),rowName);

/**
 * Adds fields to an object
 */

_RqlObject object(args) => new _RqlObject(args);

/**
 * change the string to uppercase
 */
 _RqlUpCase upcase(String str) => new _RqlUpCase(str);

 /**
  * Change a string to lowercase
  */
 _RqlDownCase downcase(String str) => new _RqlDownCase(str);

 _RqlTerm expr(val) => _expr(val);

 noSuchMethod(Invocation invocation) {
       var methodName = invocation.memberName;
       List tmp = invocation.positionalArguments;
             List args = [];
             Map options = null;
             for(var i=0; i < tmp.length; i++){
               if(tmp[i] is Map && i == tmp.length-1)
                 options = tmp[i];
               else
                 args.add(tmp[i]);
             }

       if(methodName == const Symbol("object"))
         return this.object(args);
       if(methodName == const Symbol("rqlDo"))
         return this.rqlDo(args.sublist(0, args.length-1),args[args.length-1]);
     }

int monday = 1;
int tuesday = 2;
int wednesday = 3;
int thursday = 4;
int friday = 5;
int saturday = 6;
int sunday = 7;
}
