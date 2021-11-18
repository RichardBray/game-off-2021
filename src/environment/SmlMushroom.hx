package environment;

import flixel.FlxSprite;

class SmlMushroom extends FlxSprite {
  public function new(x: Float = 0, y: Float = 0) {
    super(x, y);
    this.loadGraphic("assets/images/environment/smlMushroom.png", false, 302, 231);
  }
}