import '../domain/models/team.dart';

abstract final class Routes {
  static const routine = '/routine';
  static const teams = '/teams';
  static const newTeam = '/teams/new';
  static const importTeam = '/teams/import';

  /// [newTeam] or [importTeam] for [side]: `?side=opponent` for an
  /// opponent's team.
  static String newTeamOn(TeamSide side) => _onSide(newTeam, side);
  static String importTeamOn(TeamSide side) => _onSide(importTeam, side);

  static String _onSide(String path, TeamSide side) =>
      side == TeamSide.mine ? path : '$path?side=${side.name}';

  /// The side a [newTeamOn] / [importTeamOn] link asks for.
  static TeamSide sideOf(Uri uri) =>
      TeamSide.values.asNameMap()[uri.queryParameters['side']] ?? TeamSide.mine;
  static String team(String id) => '/teams/$id';
  static String editTeam(String id) => '/teams/$id/edit';
  static const logGame = '/log';
  static const progress = '/progress';
}
