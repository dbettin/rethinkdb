#!/bin/bash

set -e

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" )/.. && pwd )

echo "Analyzing Rethinkdb library...."
#dartanalyzer --show-package-warnings $DIR/lib/rethinkdb.dart

echo "Running Rethinkdb unit tests...."
dart --checked $DIR/test/rethinkdb_test.dart