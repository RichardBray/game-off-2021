package environment;
import characters.Player;

import environment.ClimableSprite.ClimeableSpriteOptions;

import flixel.FlxObject;
import flixel.FlxSprite;

using echo.FlxEcho;

class Mushroom extends ClimableSprite {
  public var stalkCollision: FlxObject;
  final smallMushroomColliisonShape: Array<Array<Float>> = [[0, 0], [60, -9.5], [130.5, -13], [280, -11.5], [280.5, 11.5], [0, 9.5]];
  final largeMushroomColliisonShape: Array<Array<Float>> = [[0, 0], [14, -22], [68, -40], [162, -55], [258, -63], [305, -59.5], [400, -35], [450, 0]];

  public function new(x: Int, y: Int, player: Player, type: MushroomTypes) {
    final climableSpriteOptions: ClimeableSpriteOptions = {
      x: x,
      y: y,
      player: player,
      imageWidth: 0,
      imageHeight: 0,
      vertices: smallMushroomColliisonShape,
      frameName: "",
      spriteSheet: "environment/mushrooms",
      collisionOffsetX: -20,
      collisionOffsetY: -45,
      climeableTriggerOffsetY: 0,
      climeableTriggerOffsetX: 0,
    }

    switch(type) {
      case SmallRed:
        climableSpriteOptions.frameName = "Mushrooms-01.png";
        updatesForSmallMushroom(climableSpriteOptions);
      case SmallBlue:
        climableSpriteOptions.frameName = "Mushrooms-03.png";
        updatesForSmallMushroom(climableSpriteOptions);
      case LargeRed:
        climableSpriteOptions.frameName = "Mushrooms-02.png";
        updatesForLargeMushroom(climableSpriteOptions);
      case LargeBlue:
        climableSpriteOptions.frameName = "Mushrooms-04.png";
        updatesForLargeMushroom(climableSpriteOptions);
    }

    super(climableSpriteOptions);

    if (type == SmallRed || type == SmallBlue) {
      this.sprtImage.offset.x = -100;
      this.sprtImage.offset.y = -142;
      stalkCollision = new FlxObject((x + 118), (y + 79), 58, 152);
    } else {
      this.sprtImage.offset.y = 55;
      stalkCollision = new FlxObject((x + 118), (y - 50), 58, 400);
    }

    stalkCollision.add_body({ mass: 0 });
    add(stalkCollision);
    player.listen(stalkCollision);
  }

  function updatesForLargeMushroom(climableSpriteOptions: ClimeableSpriteOptions) {
    climableSpriteOptions.imageWidth = 302;
    climableSpriteOptions.imageHeight = 304;
    climableSpriteOptions.vertices = largeMushroomColliisonShape;
    climableSpriteOptions.collisionOffsetY = 140;
    climableSpriteOptions.collisionOffsetX = 155;
    climableSpriteOptions.climeableTriggerOffsetX = -90;
  }

  function updatesForSmallMushroom(climableSpriteOptions: ClimeableSpriteOptions) {
    climableSpriteOptions.imageWidth = 302;
    climableSpriteOptions.imageHeight = 231;
    climableSpriteOptions.climeableTriggerOffsetY = climableSpriteOptions.imageHeight / 2;
  }
}

enum MushroomTypes {
  SmallRed;
  SmallBlue;
  LargeRed;
  LargeBlue;
}