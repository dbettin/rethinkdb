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

      if (value is String) {
        _buildStringOption(key, value);
      }

      if (value is num) {
        _buildNumOption(key, value);
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

abstract class DurabilityOptionMixin {
  String get durability                => options["durability"];
         set durability(String value)  => options["durability"] = value;
}

abstract class UseOutdatedOptionMixin {
  bool   get useOutdated              => options["use_outdated"];
         set useOutdated(bool value)  => options["use_outdated"] = value;
}

class RunOptions extends RqlOptions with DurabilityOptionMixin, UseOutdatedOptionMixin {

  RunOptions({noReply, useOutdated, durability}) {
    this.noReply = noReply;
    this.useOutdated = useOutdated;
    this.durability = durability;
  }

  bool   get noReply                  => options["noReply"];
         set noReply(bool value)      => options["noReply"] = value;
}

class TableCreateOptions extends RqlOptions with DurabilityOptionMixin {

  TableCreateOptions({primayKey, datacenter, cacheSize, durability}) {
    this.primayKey = primayKey;
    this.datacenter = datacenter;
    this.cacheSize = cacheSize;
    this.durability = durability;
  }

  String get primayKey                => options["primary_key"];
         set primayKey(String value)  => options["primary_key"] = value;

  String get datacenter               => options["datacenter"];
         set datacenter(String value) => options["datacenter"] = value;

  num get cacheSize                => options["cache_size"];
         set cacheSize(num value)  => options["cache_size"] = value;
}

class TableOptions extends RqlOptions with UseOutdatedOptionMixin {

  TableOptions({useOutdated}) {
    this.useOutdated = useOutdated;
  }
}

