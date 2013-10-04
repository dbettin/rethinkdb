Dart RethinkDB Driver
=========

A [Dart](http://www.dartlang.org) driver for [RethinkDB](http://www.rethinkdb.com).

This project is a fork of [Dave Bettins rethink driver](https://github.com/dbettin/rethinkdb)

Not all functionality has been implemented.


Getting Started:
========

The driver api tries to align with the javascript and python RethinkDB drivers. You can read their documentation [here](http://www.rethinkdb.com/api/).

  clone the repository:
  ```
    git clone https://github.com/billysometimes/rethinkdb.git
  ````
  open the project in Dart Editor and view examples.dart to see the available features and how to use them.

  to include this driver in your own project add:
    ```
    import 'lib/rethinkdb.dart';
    ````
  to your project.

Running Tests:
========

Install the latest version of RethinkDB locally and run with the defaults.
_Note: all tests are ran against a live version of the DB._

To execute the drivers' tests, from the root project dir, please run:

```
tools\build.sh
````



