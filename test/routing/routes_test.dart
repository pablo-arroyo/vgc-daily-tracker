import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/routing/routes.dart';

void main() {
  test("links for your own teams stay plain; opponents' add a side", () {
    expect(Routes.newTeamOn(TeamSide.mine), '/teams/new');
    expect(Routes.importTeamOn(TeamSide.mine), '/teams/import');
    expect(Routes.newTeamOn(TeamSide.opponent), '/teams/new?side=opponent');
    expect(
      Routes.importTeamOn(TeamSide.opponent),
      '/teams/import?side=opponent',
    );
  });

  test('sideOf reads the link back, defaulting to your own', () {
    expect(
      Routes.sideOf(Uri.parse('/teams/new?side=opponent')),
      TeamSide.opponent,
    );
    expect(Routes.sideOf(Uri.parse('/teams/new')), TeamSide.mine);
    expect(Routes.sideOf(Uri.parse('/teams/new?side=bogus')), TeamSide.mine);
  });
}
