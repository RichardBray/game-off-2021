package environment;

import characters.Player;
import environment.Mushroom.MushroomTypes;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;


class Mushrooms extends FlxTypedGroup<Mushroom> {

  final mushrooms: Array<MushroomObj> = [
    {
      x: 4195,
      y: 604,
      type: SmallRed,
    },
    {
      x: 7118,
      y: 604,
      type: SmallRed,
    },
    {
      x: 10454,
      y: 604,
      type: SmallBlue,
    },
    {
      x: 10756,
      y: 491,
      type: LargeRed,
    },
    {
      x: 15831,
      y: 491,
      type: LargeBlue,
    },
    {
      x: 20007,
      y: 604,
      type: SmallBlue,
    },
  ];

  public function new(player: Player) {
    super(mushrooms.length);

    for (mushroom in mushrooms) {
      final mushrromSprite = new Mushroom(mushroom.x, mushroom.y, player, mushroom.type);
      add(mushrromSprite);
    }
  }
}

typedef MushroomObj = {
  x: Int,
  y: Int,
  type: MushroomTypes
}