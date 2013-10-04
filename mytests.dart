import 'lib/rethinkdb.dart';
import 'dart:async';

main() {
  connect(db:"test").then((conn)=>getEm(conn));




}
Future getEm(connection)
{
  tableList().run(connection).then((tba) => print('connected to db'));
  List heros = [{ 'i am making a note': 'for science'},{'this is':'incredible'}];
  table("guitars").insert(heros).run(connection)
      .then((tba){
         if(tba.inserted){
           print('records inserted');
         }
      });
}

