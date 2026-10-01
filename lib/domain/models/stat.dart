/// The six stats, labelled the way Showdown writes them.
enum Stat {
  hp('HP', 'HP'),
  atk('Atk', 'Attack'),
  def('Def', 'Defense'),
  spa('SpA', 'Special Attack'),
  spd('SpD', 'Special Defense'),
  spe('Spe', 'Speed');

  const Stat(this.label, this.fullName);

  final String label;

  /// Spelled out, for screen readers.
  final String fullName;
}
