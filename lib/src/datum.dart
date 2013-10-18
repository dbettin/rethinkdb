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

  _RqlDatumObject(val) {
    if(val is Map)
      this.value = val;
    else
    {
      val.forEach((element){
        value[element.key] = _buildDatumResponseValue(element.val);
      });
    }
  }

  _buildProtoDatum() {
    var datum = new Datum();
    datum.type = Datum_DatumType.R_OBJECT;
    value.forEach((k,v){
      Datum_AssocPair d = new Datum_AssocPair();
      d.key = k;
      d.val = v._buildProtoDatum();
      datum.rObject.add(d);});
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
        if(v is Datum)
          value.add(_buildDatumResponseValue(v));
        else
          value.add(v);
    });
  }

  _buildProtoDatum() {
    var datum = new Datum();
    datum.type = Datum_DatumType.R_ARRAY;
    value.forEach((element)=>datum.rArray.add(element._buildProtoDatum()));
    return datum;
  }
}