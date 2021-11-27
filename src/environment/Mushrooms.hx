package environment;

import characters.Player;
import environment.Mushroom.MushroomTypes;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;


class Mushrooms extends FlxTypedGroup<Mushroom> {

  final mushrooms: Array<MushroomObj> = [
    {
      x: 3195,
      y: 604,
      type: SmallRed,
    },
    {
      x: 6118,
      y: 604,
      type: SmallRed,
    },
    {
      x: 9454,
      y: 604,
      type: SmallBlue,
    },
    {
      x: 9756,
      y: 491,
      type: LargeRed,
    },
    {
      x: 13831,
      y: 491,
      type: LargeBlue,
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