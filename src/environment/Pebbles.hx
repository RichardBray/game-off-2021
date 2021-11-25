package environment;

import characters.Player;
import environment.Pebble.PebbleTypes;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;

class Pebbles extends FlxTypedGroup<Pebble> {

  final pebbles: Array<PebbleObj> = [
    {
      x: 905,
      y: 805,
      type: Small
    },
    {
      x: 1293,
      y: 805,
      type: Small
    },
    {
      x: 5672,
      y: 805,
      type: Small
    },
  ];

  public function new(player: Player) {
    super(pebbles.length);

    for (pebble in pebbles) {
      final pebbleSprt: Pebble = new Pebble(pebble.x, pebble.y, pebble.type);
      pebbleSprt.add_body({mass: 0});
      player.listen(pebbleSprt);
      add(pebbleSprt);
    }
  }
}

typedef PebbleObj = {
  x: Int,
  y: Int,
  type: PebbleTypes
}