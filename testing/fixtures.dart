import 'dart:io';

/// Reads a recorded response from `testing/fixtures/`, e.g.
/// `fixture('pokeapi/pokemon_kingambit.json')`.
///
/// Paths are relative to the project root, which is the working directory
/// for `flutter test`.
String fixture(String path) =>
    File('testing/fixtures/$path').readAsStringSync();
