package utils;

import characters.Player;

import flixel.group.FlxGroup.FlxTypedGroup;


class Checkpoints extends FlxTypedGroup<Checkpoint> {
  final checkpoints: Array<Array<Int>> = [
    [4849, 511],
    [9696, 727],
    [13030, 58],
    [16563, 727],
    [19580, 727],
  ];

  public function new(player: Player) {
    super(checkpoints.length);

    for (checkpoint in checkpoints) {
      final checkpoint = new Checkpoint(checkpoint[0], checkpoint[1], player);
      add(checkpoint);
    }
  }
}
