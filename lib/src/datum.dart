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
  Datum _buildProtoDatum();

}

class _RqlDatumString extends _RqlDatum {

  String value;

  _RqlDatumString(this.value);

  Datum _buildProtoDatum() {
    var datum = new Datum();
    datum.type = Datum_DatumType.R_STR;
    datum.rStr = value;
    return datum;
  }

}

class _RqlDatumObject extends _RqlDatum {
  Map<String, dynamic> value = {};

  _RqlDatumObject(List<Datum_AssocPair> assocPair) {
    assocPair.forEach((pair) => value[pair.key] = _buildDatumResponseValue(pair.val));
  }
  Datum _buildProtoDatum() {
    // TODO implement this method
  }

}

class _RqlDatumBool extends _RqlDatum {

  bool value;

  _RqlDatumBool(this.value);

  Datum _buildProtoDatum() {
    var datum = new Datum();
    datum.type = Datum_DatumType.R_BOOL;
    datum.rBool = value;
    return datum;
  }
}

class _RqlDatumNum extends _RqlDatum {

  num value;

  _RqlDatumNum(this.value);

  Datum _buildProtoDatum() {
    var datum = new Datum();
    datum.type = Datum_DatumType.R_NUM;
    datum.rNum = value.toDouble();
    return datum;
  }
}

class _RqlDatumArray extends _RqlDatum {

  List value = [];

  _RqlDatumArray(data) {
    data.forEach((datum) => value.add(_buildDatumResponseValue(datum)));
  }

  Datum _buildProtoDatum() {
    // TODO implement this method
  }
}