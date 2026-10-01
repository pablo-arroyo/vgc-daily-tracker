abstract final class Routes {
  static const routine = '/routine';
  static const teams = '/teams';
  static const newTeam = '/teams/new';
  static const importTeam = '/teams/import';
  static String team(String id) => '/teams/$id';
  static String editTeam(String id) => '/teams/$id/edit';
  static const logGame = '/log';
  static const progress = '/progress';
}
