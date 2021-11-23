package environment;

import characters.Player;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;

class Pebbles extends FlxTypedGroup<FlxSprite> {

  public function new(player: Player) {
    super(2);

		final pebble = new Pebble(905, 805, Small);
    add(pebble);

		final pebbleTwo = new Pebble(1293, 805, Large);
    add(pebbleTwo);

    this.forEach((member) -> {
      member.add_body({mass: 0});
      player.listen(member);
    });
  }
}