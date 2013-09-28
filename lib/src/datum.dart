part of rethinkdb;


_buildDatumResponseValue(Datum datum) {
  switch(datum.type) {
    case Datum_DatumType.R_STR:
      return new _RqlDatumString(datum.rStr).value;
    case Datum_DatumType.R_NUM:
      return new _RqlDatumNum(datum.rNum).value;
    case Datum_DatumType.R_BOOL:
      return new _RqlDatumBool(datum.rBool).value;
    case Datum_DatumType.R_OBJECT:
      return new _RqlDatumObject(datum.rObject).value;
    case Datum_DatumType.R_ARRAY:
      return new _RqlDatumArray(datum.rArray).value;
    default:
      return null;
  }
}

abstract class _RqlDatum<T> extends _RqlTerm {
  _RqlDatum() : super(Term_TermType.DATUM);

  Term _buildProtoTerm() {
    var term = new Term();
    term.type = _termType;
    term.datum = _buildProtoDatum();
    return term;
  }

  T value;
  _buildProtoDatum();

}

class _RqlDatumString extends _RqlDatum {

  String value;

  _RqlDatumString(this.value);

  _buildProtoDatum() {
    var datum = new Datum();
    datum.type = Datum_DatumType.R_STR;
    datum.rStr = value;
    return datum;
  }

}

class _RqlDatumObject extends _RqlDatum {
  Map value = {};

  _RqlDatumObject(List<Datum_AssocPair> assocPair) {
    assocPair.forEach((element)=>
        value[element.key] = element);
  }
  _buildProtoDatum() {
    var datum = new Datum();
    datum.type = Datum_DatumType.R_OBJECT;
    value.forEach((k,v){datum.rObject.add(v);});
    return datum;
  }

}

class _RqlDatumBool extends _RqlDatum {

  bool value;

  _RqlDatumBool(this.value);

  _buildProtoDatum() {
    var datum = new Datum();
    datum.type = Datum_DatumType.R_BOOL;
    datum.rBool = value;
    return datum;
  }
}

class _RqlDatumNum extends _RqlDatum {

  num value;

  _RqlDatumNum(this.value);

  _buildProtoDatum() {
    var datum = new Datum();
    datum.type = Datum_DatumType.R_NUM;
    datum.rNum = value.toDouble();
    return datum;
  }
}

class _RqlDatumArray extends _RqlDatum {

  List value = [];

  _RqlDatumArray(data) {
    data.forEach((v){
      var datum = new Datum();
      if(v is String)
      {
        datum = new _RqlDatumString(v);
      }
      if(v is bool)
      {
        datum = new _RqlDatumBool(v);
      }
      if(v is Map)
      {
        datum = new _RqlDatumObject(v);
      }
      if(v is num)
      {
        datum = new _RqlDatumNum(v);
      }
      if(v is List)
      {
        datum = new _RqlDatumArray(v);
      }
      value.add(_buildDatumResponseValue(v));
    });
  }

  _buildProtoDatum() {
    // TODO implement this method
  }
}