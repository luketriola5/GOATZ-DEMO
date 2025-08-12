
import 'dart:math';
import '../models/athlete.dart';

abstract class DataRepository {
  Future<List<Athlete>> fetchAll();
  Future<Map<String, String>> getDailyChallenge(); // returns {'a': idA, 'b': idB}
}

class DemoRepository implements DataRepository {
  final List<Athlete> _all;
  DemoRepository(this._all);

  @override
  Future<List<Athlete>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _all;
  }

  @override
  Future<Map<String, String>> getDailyChallenge() async {
    final rng = Random();
    final a = _all[rng.nextInt(_all.length)];
    var b = _all[rng.nextInt(_all.length)];
    while (b.id == a.id) { b = _all[rng.nextInt(_all.length)]; }
    return {'a': a.id, 'b': b.id};
  }
}
