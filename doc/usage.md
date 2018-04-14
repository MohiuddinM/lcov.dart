path: blob/master/lib
source: src/report.dart

# Usage
**LCOV Reports for Dart** provides a set of classes representing a [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) coverage report and its data.
The `Report` class, the main one, provides the parsing and formatting features.

## Parse coverage data from a LCOV file
The `Report.fromCoverage()` constructor parses a [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) coverage report provided as string, and creates a `Report` instance giving detailed information about this coverage report:

```dart
import 'dart:async';
import 'package:lcov/lcov.dart';

Future<void> main() async {
  var coverage = await new File('lcov.info').readAsString();

  try {
    var report = new Report.fromCoverage(coverage);
    print('The coverage report contains ${report.records.length} records:');
    print(report.toJson());
  }

  on LcovException catch (err) {
    print('An error occurred: ${err.message}');
  }
}
```

!!! info
    A `LcovException` is thrown if any error occurred while parsing the coverage report.

The `Report.toJson()` instance method will return a [Map](https://api.dartlang.org/stable/dart-core/Map-class.html) like this:

```json
{
  "testName": "Example",
  "records": [
    {
      "sourceFile": "/home/cedx/lcov.dart/fixture.dart",
      "branches": {
        "found": 0,
        "hit": 0,
        "data": []
      },
      "functions": {
        "found": 1,
        "hit": 1,
        "data": [
          {"functionName": "main", "lineNumber": 4, "executionCount": 2}
        ]
      },
      "lines": {
        "found": 2,
        "hit": 2,
        "data": [
          {"lineNumber": 6, "executionCount": 2, "checksum": "PF4Rz2r7RTliO9u6bZ7h6g"},
          {"lineNumber": 9, "executionCount": 2, "checksum": "y7GE3Y4FyXCeXcrtqgSVzw"}
        ]
      }
    }
  ]
}
```

## Format coverage data to the LCOV format
Each provided class has a dedicated `toString()` instance method returning the corresponding data formatted as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) string.
All you have to do is to create the adequate structure using these different classes, and to export the final result:

```dart
import 'package:lcov/lcov.dart';

void main() {
  var lineCoverage = new LineCoverage(2, 2, [
    new LineData(6, executionCount: 2, checksum: 'PF4Rz2r7RTliO9u6bZ7h6g'),
    new LineData(7, executionCount: 2, checksum: 'yGMB6FhEEAd8OyASe3Ni1w')
  ]);

  var record = new Record('/home/cedx/lcov.dart/fixture.dart')
    ..functions = new FunctionCoverage(1, 1)
    ..lines = lineCoverage;

  var report = new Report('Example', [record]);
  print(report);
}
```

The `Report.toString()` method will return a [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) report formatted like this:

```
TN:Example
SF:/home/cedx/lcov.dart/fixture.dart
FNF:1
FNH:1
DA:6,2,PF4Rz2r7RTliO9u6bZ7h6g
DA:7,2,yGMB6FhEEAd8OyASe3Ni1w
LF:2
LH:2
end_of_record
```