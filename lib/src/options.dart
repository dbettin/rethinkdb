part of rethinkdb;


/// common options to queries
abstract class OptionsBuilder<T> {

  List _protoOptions;

  OptionsBuilder(this._protoOptions);

  buildProtoOptions(Map options) {

    options.forEach((key, value) {
      if (value is bool) {
        _buildBoolOption(key, value);
      }
      else if (value is String) {
        _buildStringOption(key, value);
      }

      else if (value is num) {
        _buildNumOption(key, value);
      }
      else {
        _addToProtoOptions(value,key);
      }
    });
  }

  _buildStringOption(key, value) {
    if (value != null && value.isNotEmpty) {
      var term = new _RqlDatumString(value);
      _addToProtoOptions(term, key);
    }
  }

  _buildBoolOption(key, value) {
    if (value != null) {
      var term = new _RqlDatumBool(value);
      _addToProtoOptions(term, key);
    }
  }

  _buildNumOption(key, value) {
    if (value != null) {
      var term = new _RqlDatumNum(value);
      _addToProtoOptions(term, key);
    }
  }

  _addToProtoOptions(term, key) {
    _protoOptions.add(_buildPair(term._buildProtoTerm(), key));
  }

  T _buildPair(term, key);

}

class QueryOptionsBuilder extends OptionsBuilder {

  QueryOptionsBuilder(List protoOptions) : super(protoOptions);

  Query_AssocPair _buildPair(Term value, String key) {
    var pair = new Query_AssocPair();
    pair.key = key;
    pair.val = value;
    return pair;
  }
}

class TermOptionsBuilder extends OptionsBuilder {

  TermOptionsBuilder(List protoOptions) : super(protoOptions);

  Term_AssocPair _buildPair(Term value, String key) {
    var pair = new Term_AssocPair();
    pair.key = key;
    pair.val = value;
    return pair;
  }
}


abstract class RqlOptions {
  final Map<String, dynamic> options = {};
}


