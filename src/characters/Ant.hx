package characters;

import flixel.FlxObject;
import flixel.FlxSprite;

using echo.FlxEcho;
using utils.SpriteHelpers;

class Ant extends FlxSprite {
  public var state: AntStates = Standing;

  public function new(x: Float = 0, y: Float = 0) {
    super(x, y);
    this.loadFrames("characters/ant");
    this.setAnimationByFrames({
      name: "running",
      totalFrames: 11,
      frameNamePrefix: "Ant_Run-",
      frameRate: 10,
    });
    this.setAnimationByFrames({
      name: "attacking",
      totalFrames: 17,
      frameNamePrefix: "Ant_Attack_",
      frameRate: 10,
    });

    this.add_body();

		// - facing directions
		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
  }

  function stateMachine() {
    final physicsBody = this.get_body();
    switch(state) {
      case Running:
        this.animation.play("running");
      case Attacking:
        physicsBody.velocity.x = 0;
        this.animation.play("standing");
      case Standing:
        physicsBody.velocity.x = 0;
    }
  }

	override function update(elapsed: Float) {
		stateMachine();
		super.update(elapsed);
	}
}

enum AntStates {
  Running;
  Attacking;
  Standing;
}