import '../../../repository/crash_repository.dart';

class CrashController {
  final CrashRepository crashRepository = CrashRepository();

  Stream<List<String>?> getData() async* {
    final String response =
        ((await crashRepository.getSignal()).data as String);

    final RegExpMatch? element =
        RegExp(r'<h2.+?>(.+?)<\/h2>.+?num-casas.+?>(.+?)<\/span>')
            .firstMatch(response);

    if (element != null) {
      yield [(element[1] as String), (element[2] as String)];
    } else {
      yield null;
    }
    await Future.delayed(const Duration(seconds: 3));
    yield* getData();
  }

  Stream<String> getChance() async* {
    yield ((await crashRepository.getChance()).data as String);
    await Future.delayed(const Duration(seconds: 3));
    yield* getChance();
  }
}
