package environment;

import flixel.FlxSprite;
import utils.Colors;

class Pebble extends FlxSprite {
  public function new(x: Float, y: Float) {
    super(x, y);
    this.makeGraphic(30, 30, Colors.grey);
  }
}