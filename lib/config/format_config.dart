/// A team shipped with the app for the current format.
class SampleTeam {
  const SampleTeam({required this.name, required this.paste});

  final String name;

  /// Showdown export text.
  final String paste;
}

/// The VGC format the app is set up for. Changing format means swapping
/// this config, not editing screens.
class FormatConfig {
  const FormatConfig({required this.label, required this.sampleTeams});

  /// Shown in the app header, e.g. `Reg M-C`.
  final String label;

  /// Teams the player can add in one tap from an empty Teams tab.
  final List<SampleTeam> sampleTeams;

  /// Regulation M-C (Sept 9 – Dec 1, 2026), with the three teams from the
  /// "VGC Reg M-C Teams: EVs & Analysis" artifact.
  static const regMC = FormatConfig(
    label: 'Reg M-C',
    sampleTeams: [
      SampleTeam(name: 'Mega Metagross (Worlds 2026)', paste: _metagrossPaste),
      SampleTeam(
        name: 'Rillaboom / Sneasler Grassy Offense',
        paste: _grassyPaste,
      ),
      SampleTeam(name: 'Big Six', paste: _bigSixPaste),
    ],
  );
}

const _metagrossPaste = '''
Kingambit @ Chople Berry
Ability: Defiant
Level: 50
EVs: 252 HP / 252 Atk / 4 SpD
Adamant Nature
- Protect
- Kowtow Cleave
- Sucker Punch
- Low Kick

Kleavor @ Focus Sash
Ability: Sharpness
Level: 50
EVs: 4 HP / 252 Atk / 252 Spe
Adamant Nature
- Protect
- Stone Axe
- X-Scissor
- Feint

Metagross @ Metagrossite
Ability: Clear Body
Level: 50
EVs: 4 HP / 252 Atk / 252 Spe
Jolly Nature
- Protect
- Iron Head
- Psychic Fangs
- Ice Punch

Whimsicott @ Fairy Feather
Ability: Prankster
Level: 50
EVs: 252 HP / 4 SpD / 252 Spe
Timid Nature
- Protect
- Moonblast
- Tailwind
- Encore

Raichu @ Raichunite Y
Ability: Lightning Rod
Level: 50
EVs: 4 HP / 252 SpA / 252 Spe
Timid Nature
- Protect
- Zap Cannon
- Focus Blast
- Fake Out

Basculegion @ Life Orb
Ability: Adaptability
Level: 50
EVs: 4 HP / 252 Atk / 252 Spe
Adamant Nature
- Protect
- Wave Crash
- Last Respects
- Aqua Jet
''';

const _grassyPaste = '''
Rillaboom @ Miracle Seed
Ability: Grassy Surge
Level: 50
EVs: 252 HP / 252 Atk / 4 SpD
Adamant Nature
- Protect
- Wood Hammer
- Grassy Glide
- Fake Out

Sneasler @ Grassy Seed
Ability: Unburden
Level: 50
EVs: 4 HP / 252 Atk / 252 Spe
Adamant Nature
- Protect
- Close Combat
- Dire Claw
- Acrobatics

Incineroar @ Rocky Helmet
Ability: Intimidate
Level: 50
EVs: 252 HP / 4 Atk / 252 SpD
Careful Nature
- Fake Out
- Knock Off
- Parting Shot
- Flare Blitz

Kingambit @ Life Orb
Ability: Defiant
Level: 50
EVs: 252 HP / 252 Atk / 4 Spe
Adamant Nature
- Protect
- Kowtow Cleave
- Sucker Punch
- Iron Head

Salamence @ Salamencite
Ability: Intimidate → Aerilate
Level: 50
EVs: 4 HP / 252 Atk / 252 Spe
Jolly Nature
- Protect
- Double-Edge
- Dragon Claw
- Tailwind

Grimmsnarl @ Light Clay
Ability: Prankster
Level: 50
EVs: 252 HP / 4 Atk / 252 SpD
Careful Nature
- Light Screen
- Reflect
- Thunder Wave
- Spirit Break
''';

const _bigSixPaste = '''
Charizard @ Charizardite Y
Ability: Blaze → Drought
Level: 50
EVs: 4 HP / 252 SpA / 252 Spe
Timid Nature
- Protect
- Heat Wave
- Weather Ball
- Solar Beam

Floette @ Floettite
Ability: Flower Veil → Fairy Aura
Level: 50
EVs: 4 Def / 252 SpA / 252 Spe
Timid Nature
- Protect
- Moonblast
- Calm Mind
- Psychic

Basculegion @ Mystic Water
Ability: Adaptability
Level: 50
EVs: 4 HP / 252 Atk / 252 Spe
Adamant Nature
- Protect
- Wave Crash
- Last Respects
- Aqua Jet

Kingambit @ Focus Sash
Ability: Defiant
Level: 50
EVs: 4 HP / 252 Atk / 252 Spe
Adamant Nature
- Protect
- Kowtow Cleave
- Sucker Punch
- Low Kick

Whimsicott @ Fairy Feather
Ability: Prankster
Level: 50
EVs: 252 HP / 4 SpD / 252 Spe
Timid Nature
- Protect
- Moonblast
- Tailwind
- Encore

Garchomp @ Sitrus Berry
Ability: Rough Skin
Level: 50
EVs: 252 HP / 4 Atk / 252 Spe
Jolly Nature
- Protect
- Earthquake
- Dragon Claw
- Stomping Tantrum
''';
