package utils;

import characters.Player;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class Checkpoints extends FlxTypedGroup<Checkpoint> {
  final checkpoints: Array<Array<Int>> = [
    [3849, 511],
    [8696, 726],
    [11006, 58],
  ];

  public function new(player: Player) {
    super(checkpoints.length);

    for (checkpoint in checkpoints) {
      final checkpoint = new Checkpoint(checkpoint[0], checkpoint[1], player);
      add(checkpoint);
    }
  }
}
