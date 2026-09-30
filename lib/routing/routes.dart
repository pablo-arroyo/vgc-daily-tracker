abstract final class Routes {
  static const routine = '/routine';
  static const teams = '/teams';
  static const newTeam = '/teams/new';
  static String editTeam(String id) => '/teams/$id/edit';
  static const logGame = '/log';
  static const progress = '/progress';
}
