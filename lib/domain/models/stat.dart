/// The six stats, labelled the way Showdown writes them.
enum Stat {
  hp('HP'),
  atk('Atk'),
  def('Def'),
  spa('SpA'),
  spd('SpD'),
  spe('Spe');

  const Stat(this.label);

  final String label;
}
