import 'package:lcov/lcov.dart';
import 'package:test/test.dart';

/// Tests the features of the branch coverage.
void main() => group('BranchCoverage', () {
  group('.fromJson()', () {
    test('should return an instance with default values for an empty map', () {
      var coverage = new BranchCoverage.fromJson(const {});
      expect(coverage.data, allOf(isList, isEmpty));
      expect(coverage.found, equals(0));
      expect(coverage.hit, equals(0));
    });

    test('should return an initialized instance for a non-empty map', () {
      var coverage = new BranchCoverage.fromJson({
        'data': [const {'lineNumber': 127}],
        'found': 3,
        'hit': 19
      });

      expect(coverage.data, allOf(isList, hasLength(1)));
      expect(coverage.data.first, const isInstanceOf<BranchData>());
      expect(coverage.found, equals(3));
      expect(coverage.hit, equals(19));
    });
  });

  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      var map = new BranchCoverage().toJson();
      expect(map, allOf(isMap, hasLength(3)));
      expect(map['data'], allOf(isList, isEmpty));
      expect(map['found'], equals(0));
      expect(map['hit'], equals(0));
    });

    test('should return a non-empty map for an initialized instance', () {
      var map = new BranchCoverage(3, 19, [new BranchData()]).toJson();
      expect(map, allOf(isMap, hasLength(3)));
      expect(map['data'], allOf(isList, hasLength(1)));
      expect(map['data'].first, isMap);
      expect(map['found'], equals(3));
      expect(map['hit'], equals(19));
    });
  });

  group('.toString()', () {
    test(r'should return a format like "BRF:<found>\nBRH:<hit>"', () {
      expect(new BranchCoverage().toString(), equals('BRF:0\nBRH:0'));

      var data = new BranchData(127, 3, 2);
      expect(new BranchCoverage(3, 19, [data]).toString(), equals('$data\nBRF:3\nBRH:19'));
    });
  });
});