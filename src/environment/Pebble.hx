package environment;

import flixel.FlxSprite;
import utils.Colors;

using utils.SpriteHelpers;
class Pebble extends FlxSprite {
  public function new(x: Float, y: Float) {
    super(x, (y + 15));

    this.makeGraphic(30, 30, Colors.grey);
		this.changeHitboxSize({
			reduceWidthBy: 15,
			reduceHeightBy: 15,
			heightOffset: 8,
			widthOffset: 0,
		});
  }
}