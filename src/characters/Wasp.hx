package characters;

import characters.Player;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxPath;

using echo.FlxEcho;

using flixel.tweens.FlxTween;

using utils.SpriteHelpers;

class Wasp extends FlxSprite {
	public var state: WaspStates = Standing;
	public var triggerSkyFly = false;
	public var alertOne = false;
	public var alertTwo = false;
	public var followPathSet = false;

	var flyThroughSkyTimer: Float = 0;
	var followPathTimer: Float = 0;
	var pathFollowedSet = false;
	var waspDescendSet = false;

	var buzzingSound: FlxSound;

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
			totalFrames: 16,
			frameNamePrefix: "WaspFly_",
			frameRate: 10,
		});
		this.setAnimationByFrames({
			name: "landing",
			totalFrames: 6,
			frameNamePrefix: "WaspLand_",
			frameRate: 10,
		});
		this.setAnimationByFrames({
			name: "attacking",
			totalFrames: 11,
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

		buzzingSound = FlxG.sound.load('assets/sounds/buzzing.ogg', 0.6);

	}

	function stateMachine(elapsed: Float) {
		switch (state) {
			case Flying:
				final FLYING_SPEED = 680;
				velocity.x = FLYING_SPEED;
				this.animation.play("flying");
				buzzingSound.play();
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
				buzzingSound.play();
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
		state = Hovering;
		if (!waspDescendSet) {
			this.tween({y: 560}, 3, {ease: FlxEase.sineInOut});
			waspDescendSet = true;
		}
	}

	function followPath(elapsed: Float) {
		followPathTimer += elapsed;
		if (!pathFollowedSet) {
			this.facing = FlxObject.LEFT;
			path.start(null, 440);
			pathFollowedSet = true;
		}

		if (followPathTimer > 2) {
			alertOne = true;
		}

		if (followPathTimer > 4 && followPathTimer < 7) {
			alertOne = false;
      this.tween({x: 19749, y: 200}, 1);
		}

		if (followPathTimer > 5) {
      this.facing = FlxObject.RIGHT;
      alertOne = false;
      alertTwo = true;
		}

    if (followPathTimer > 7) {
      this.facing = FlxObject.LEFT;
      this.tween({x: 17249}, 3);
      alertTwo = false;
      alertOne = false;
    }

    if (followPathTimer > 10) {
      this.kill();
      followPathTimer = 0;
      followPathSet = false;
    }
	}

	public function attackPlayer(player: Player,
			?facing: FlxDirectionFlags = FlxObject.LEFT) {
		this.state = Attacking;
		this.facing = facing;
		this.tween({x: player.x, y: (player.y - 100)}, 1);
	}

	override function update(elapsed: Float) {
		stateMachine(elapsed);
		if (triggerSkyFly) {
			flyThroughSky(elapsed);
		}

		if (followPathSet) {
			followPath(elapsed);
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