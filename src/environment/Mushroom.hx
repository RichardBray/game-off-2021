package environment;
import characters.Player;
import flixel.FlxObject;

using echo.FlxEcho;

class Mushroom extends ClimableSprite {
  public var stalkCollision: FlxObject;

  public function new(x: Int, y: Int, player: Player, type: MushroomTypes) {
    final smallMushroomColliisonShape: Array<Array<Float>> = [[0, 0], [60, -9.5], [130.5, -13], [218, -11.5], [280.5, -1], [280.5, 11.5], [0, 9.5]];
    final climableSpriteOptions = {
      x: x,
      y: y,
      player: player,
      imageName: "",
      imageWidth: 0,
      imageHeight: 0,
      vertices: smallMushroomColliisonShape,
      frameName: "",
      spriteSheet: "environment/mushrooms",
    }

    switch(type) {
      case SmallRed:
        climableSpriteOptions.frameName = "Mushrooms-01.png";
        climableSpriteOptions.imageWidth = 302;
        climableSpriteOptions.imageHeight = 231;
      case SmallBlue:
        climableSpriteOptions.frameName = "Mushrooms-03.png";
        climableSpriteOptions.imageWidth = 302;
        climableSpriteOptions.imageHeight = 231;
      case LargeRed:
        climableSpriteOptions.frameName = "Mushrooms-02.png";
        climableSpriteOptions.imageWidth = 302;
        climableSpriteOptions.imageHeight = 304;
      case LargeBlue:
        climableSpriteOptions.frameName = "Mushrooms-04.png";
        climableSpriteOptions.imageWidth = 302;
        climableSpriteOptions.imageHeight = 304;
    }

    super(climableSpriteOptions);

    this.sprtImage.offset.y = -38;

    //  - Stalk collision
    stalkCollision = new FlxObject((x + 118), (y + 79), 58, 152);
    stalkCollision.add_body({ mass: 0 });
    add(stalkCollision);
    player.listen(stalkCollision);
  }
}

enum MushroomTypes {
  SmallRed;
  SmallBlue;
  LargeRed;
  LargeBlue;
}