import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/config/dependencies.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_repository_remote.dart';
import 'package:vgc_daily_tracker/ui/routine/widgets/routine_screen.dart';

import '../../testing/app.dart';
import '../../testing/fakes/fake_pokemon_repository.dart';

void main() {
  testWidgets('the app built with fake dependencies exposes a '
      'PokemonRepository to its screens', (tester) async {
    await pumpApp(tester);

    final context = tester.element(find.byType(RoutineScreen));
    expect(context.read<PokemonRepository>(), isA<FakePokemonRepository>());
  });

  testWidgets('providersRemote wires the real PokemonRepositoryRemote', (
    tester,
  ) async {
    late PokemonRepository repository;
    await tester.pumpWidget(
      MultiProvider(
        providers: providersRemote(),
        child: Builder(
          builder: (context) {
            repository = context.read<PokemonRepository>();
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(repository, isA<PokemonRepositoryRemote>());
  });
}
