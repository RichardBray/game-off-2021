package characters;

import flixel.FlxObject;
import flixel.FlxSprite;
import utils.Controls;

using echo.FlxEcho;
using utils.Helpers;

class Player extends FlxSprite {
	final controls = Controls.instance;
	static inline final RUNNING_SPEED = 350;

	// - control button presses
	var rightPressed = false;
	var leftPressed = false;
	var bothDirectionsPressed = false;
	var singleDirectionPressed = false;
	var noDirectionPressed = false;

	public function new(x: Float = 0, y: Float = 0) {
		super(x, y);
		this.loadFrames("characters/girl");
		this.changeHitboxSize({
			reduceWidthBy: 30,
			reduceHeightBy: 200,
			heightOffset: 90,
			widthOffset: -5,
		});
		// - pyhsics
		this.add_body();
		// - animations
		this.setAnimationByFrames({
			name: "standing",
			totalFrames: 6,
			frameNamePrefix: "Girl_Standing-",
			frameRate: 5,
		});
		this.setAnimationByFrames({
			name: "running",
			totalFrames: 8,
			frameNamePrefix: "Girl_Run_",
			frameRate: 10,
		});
		// - facing direction
		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
	}

	function movement() {
		final body = this.get_body();
		if (controls.cross.check() && isTouching(FLOOR)) body.velocity.y -= 256;

		if (bothDirectionsPressed || noDirectionPressed) {
			body.velocity.x = 0;
			animation.play("standing");
		} else {
			body.velocity.x = rightPressed ? RUNNING_SPEED : -RUNNING_SPEED;
			animation.play("running");
			this.facing = rightPressed ? FlxObject.RIGHT : FlxObject.LEFT;
		}
	}

	function updateControls() {
		rightPressed = controls.right.check();
		leftPressed = controls.left.check();
		bothDirectionsPressed = leftPressed && rightPressed;
		singleDirectionPressed = leftPressed || rightPressed;
		noDirectionPressed = !singleDirectionPressed;
	}

	override function update(elapsed: Float) {
		super.update(elapsed);
		movement();
		updateControls();
	}
}