package environment;

import flixel.FlxSprite;

using utils.SpriteHelpers;

class TreeStumpCover extends FlxSprite {
  public function new(x: Float = 0, y: Float = 0) {
    super(x, y);

    this.loadGraphic("assets/images/environment/TreeTrunkFront_01.png", 2048, 843);
		this.changeHitboxSize({
			reduceWidthBy: 784,
			reduceHeightBy: 59,
			heightOffset: 35,
			widthOffset: -20,
		});
  }
}