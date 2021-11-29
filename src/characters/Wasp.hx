package characters;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.util.FlxPath;

using echo.FlxEcho;

using flixel.tweens.FlxTween;

using utils.SpriteHelpers;

class Wasp extends FlxSprite {

  public var state: WaspStates = Standing;
  public var triggerSkyFly: Bool = false;

  var flyThroughSkyTimer: Float = 0;
  var pathFollowedSet: Bool = false;

	final movementPathCoords: Array<{x: Float, y: Float}> = [
		{x: 20886.5, y: 485},
		{x: 20849.5, y: 330},
		{x: 20754.5, y: 180},
		{x: 20573.5, y: 101.5},
	];

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

		final flxPointCoords = movementPathCoords.map(
			coords -> new FlxPoint(coords.x, coords.y)
		);

    path = new FlxPath(flxPointCoords);

		// - facing directions
		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
  }

  function stateMachine(elapsed: Float) {
    switch(state) {
      case Flying:
        final FLYING_SPEED = 680;
        velocity.x = FLYING_SPEED;
        this.animation.play("flying");
      case Landing:
        velocity.x = 0;
        this.facing = FlxObject.LEFT;
        this.animation.play("landing");
      case Attacking:
        this.animation.play("attacking");
      case Standing:
        velocity.x = 0;
      case Hovering:
        this.animation.play("flying");
        velocity.x = 0;
    }
  }

  function flyThroughSky(elapsed: Float) {
    flyThroughSkyTimer += elapsed;

    if (flyThroughSkyTimer > .1) {
      this.alpha = 1;
      this.state = Flying;
    }
    if (flyThroughSkyTimer > 6) {
      flyThroughSkyTimer = 0;
      triggerSkyFly = false;
      this.kill();
    }
  }

  public function flyFromAbove() {
    this.tween({y: 560}, 3, {ease: FlxEase.sineInOut});
  }

  public function followPath() {
    if (!pathFollowedSet) {
      this.facing = FlxObject.LEFT;
      path.start(null, 440);
      pathFollowedSet = true;
    }
  }

	override function update(elapsed: Float) {
		stateMachine(elapsed);
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
  Hovering;
}