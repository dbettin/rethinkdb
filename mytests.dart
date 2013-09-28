import 'lib/rethinkdb.dart';
import 'dart:async';

main() {
  connect(db:"test").then((conn)=>getEm(conn));




}
Future getEm(connection)
{
  tableList().run(connection).then((tba) => print('yah'));
  //table("guitars").indexCreate("myindex").run(connection).then((tba) => print(tba));
  List heros = [{ 'i am making a note': 'for science', 'what a':'fantastic pairing'},{'this is':'incredible'}];
  table("guitars").insert(heros).run(connection).then((tba) => print('done'));
  //table('guitars').insert(heros).run(connection).then((tba) => print(tba));

}

