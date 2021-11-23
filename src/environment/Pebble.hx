package environment;

import flixel.FlxSprite;

using utils.SpriteHelpers;
class Pebble extends FlxSprite {
  public function new(x: Float, y: Float, type: PebbleTypes) {
    super(x, (y + 15));

    this.loadFrames("environment/items");

    switch(type) {
      case Small:
        this.animation.frameName = "Pebble_01.png";
        this.width = 32.5;
        this.height = 32;
        this.changeHitboxSize({
          reduceWidthBy: 20,
          reduceHeightBy: 20,
          heightOffset: 7,
          widthOffset: 0,
        });
      case Large:
        this.animation.frameName = "Pebble_02.png";
        this.width = 63;
        this.height = 28.5;
        this.changeHitboxSize({
          reduceWidthBy: 45,
          reduceHeightBy: 30,
          heightOffset: 4,
          widthOffset: 0,
        });
    }
  }
}

enum PebbleTypes {
  Small;
  Large;
}