package environment;

import flixel.FlxObject;

using echo.FlxEcho;

class SmlMushroom extends ClimableSprite {
  public var stalkCollision: FlxObject;
  public function new(x, y, player, ?flipImageX = false) {
    final defaultColliisonShape: Array<Array<Float>> = [[0, 0], [60, -9.5], [130.5, -13], [218, -11.5], [280.5, -1], [280.5, 11.5], [0, 9.5]];
    final climableSpriteOptions = {
      x: x,
      y: y,
      imageName: "smlMushroom",
      imageWidth: 302,
      imageHeight: 231,
      player: player,
      vertices: defaultColliisonShape,
    }
    super(climableSpriteOptions);

    // 2 -Stalk collision
    stalkCollision = new FlxObject((x + 112), (y + 79), 58, 152);
    stalkCollision.add_body({
      mass: 0
    });
    add(stalkCollision);
    player.listen(stalkCollision);
  }
}