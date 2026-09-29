/// "What decided this game?", with the original tracker's options.
enum MistakeCategory {
  playedWell('No major mistake — played well'),
  teamPreview('Team Preview read / game plan'),
  protectCall('Protect call / bluff'),
  speedCalc('Speed calc / turn order'),
  overcommitted('Overcommitted (greedy play)'),
  wrongBring('Wrong lead or bring choice'),
  damageCalc('Damage calc misjudged'),
  teambuildingGap('Teambuilding gap (nothing answered a threat)'),
  outplayed('Got outplayed straight up');

  const MistakeCategory(this.label);

  final String label;

  /// The one option that isn't a mistake; it's left out of the weekly focus.
  bool get isPlayedWell => this == playedWell;
}
