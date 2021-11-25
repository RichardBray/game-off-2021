package characters;

import flixel.FlxObject;
import flixel.FlxSprite;

using echo.FlxEcho;
using utils.SpriteHelpers;

class Wasp extends FlxSprite {

  public var state: WaspStates = Standing;
  public var triggerSkyFly: Bool = false;
  var flyThroughSkyTimer: Float = 0;

  public function new(x: Float = 0, y: Float = 0) {
    super(x, y);
    this.loadFrames("characters/wasp");
		this.changeHitboxSize({
			reduceWidthBy: 0,
			reduceHeightBy: 0,
		});
    this.setAnimationByFrames({
      name: "flying",
      totalFrames:16,
      frameNamePrefix: "WaspFly_",
      frameRate: 10,
    });
    this.setAnimationByFrames({
      name: "landing",
      totalFrames:6,
      frameNamePrefix: "WaspSting_",
      frameRate: 10,
    });
    this.setAnimationByFrames({
      name: "attacking",
      totalFrames:11,
      frameNamePrefix: "WaspSting_",
      frameRate: 10,
    });

    this.add_body({mass: 0});

		// - facing directions
		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
  }

  function stateMachine() {
    final physicsBody = this.get_body();
    switch(state) {
      case Flying:
        final FLYING_SPEED = 680;
        physicsBody.velocity.x = FLYING_SPEED;
        this.animation.play("flying");
      case Landing:
        physicsBody.velocity.x = 0;
        this.facing = FlxObject.LEFT;
        this.animation.play("landing");
      case Attacking:
        this.animation.play("attacking");
      case Standing:
        physicsBody.velocity.x = 0;
    }
  }

  function flyThroughSky(elapsed: Float) {
    final physicsBody = this.get_body();
    flyThroughSkyTimer += elapsed;
    physicsBody.y = 20;
    physicsBody.mass = 1;
    trace(flyThroughSkyTimer, "flyThroughSkyTimer");
    if (flyThroughSkyTimer > .1) {
      this.alpha = 1;
      this.state = Flying;
    }
    if (flyThroughSkyTimer > 6) {
      this.kill();
    }
  }
	override function update(elapsed: Float) {
		stateMachine();
    if (triggerSkyFly) {
      flyThroughSky(elapsed);
    }
		super.update(elapsed);
	}
}

enum WaspStates {
  Flying;
  Landing;
  Attacking;
  Standing;
}