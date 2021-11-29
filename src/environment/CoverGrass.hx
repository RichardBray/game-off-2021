package environment;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;


class CoverGrass extends FlxTypedGroup<FlxSprite> {
  final SPACING = 1028;
  public function new(x: Float = 0, y: Float = 0) {
    super(3);

    for (i in 0...3) {
      var grass: FlxSprite = new FlxSprite((x + SPACING * i), y);
      grass.loadGraphic("assets/images/environment/GrassforAnts.png", 1101, 1140);
      add(grass);
    }
  }
}