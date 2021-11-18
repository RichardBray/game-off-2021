package characters;

import flixel.FlxObject;
import flixel.FlxSprite;

using utils.SpriteHelpers;

class PlayerClimb extends FlxSprite {
  var spritePositionSet = false;
  public function new(x: Float = 0, y: Float = 0) {
    super(x, y);
		this.loadFrames("characters/girl");
		this.changeHitboxSize({
			reduceWidthBy: 30,
			reduceHeightBy: 200,
			heightOffset: 90,
			widthOffset: -5,
		});
    this.setAnimationByFrames({
      name: "climb",
      totalFrames: 11,
      frameNamePrefix: "Girl_Climb_",
      frameRate: 12,
    });
    this.alpha = 0;

		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
  }

  public function startClimb(player: FlxSprite) {
    if (!spritePositionSet) {
      this.alpha = 1;
      this.facing = player.facing;
      this.setPosition(player.x, player.y);
      this.animation.play("climb");
      spritePositionSet = true;
    }
  }

  public function endClimb() {
    this.alpha = 0;
    this.animation.stop();
    spritePositionSet = false;
  }

  override function update(elapsed: Float) {
    super.update(elapsed);
  }
}