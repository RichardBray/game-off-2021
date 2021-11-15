package characters;

import flixel.FlxObject;
import flixel.FlxSprite;
import utils.Controls;

using echo.FlxEcho;
using utils.Helpers;


enum PlayerStates {
	Running;
	Standing;
	RunningJump;
	StandingJump;
}

class Player extends FlxSprite {
	static inline final RUNNING_SPEED = 350;
	static inline final JUMP_VELOCITY = 300;

	final controls = Controls.instance;
	public var state(default, null): PlayerStates = Standing;

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
		this.setAnimationByFrames({
			name: "runningJump",
			totalFrames: 6,
			frameNamePrefix: "Girl_RunJump_",
			frameRate: 10,
		});
		// - facing direction
		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
	}

	function movement() {
		final body = this.get_body();
		if (controls.cross.check() && isTouching(FLOOR)) {
			body.velocity.y = -JUMP_VELOCITY;
			animation.play("runningJump");
		}

		if (bothDirectionsPressed || noDirectionPressed) {
			body.velocity.x = 0;
			animation.play("standing");
		} else {
			body.velocity.x = rightPressed ? RUNNING_SPEED : -RUNNING_SPEED;
			animation.play("running");
			this.facing = rightPressed ? FlxObject.RIGHT : FlxObject.LEFT;
		}
	}

	// function stateMachine() {
	// 	final physicsBody = this.get_body();
	// 	switch(state) {
	// 		case Standing:
	// 			if (bothDirectionsPressed || noDirectionPressed) {
	// 				physicsBody.velocity.x = 0;
	// 				animation.play("standing");
	// 			} else if () {
	// 				// standing jump
	// 			} else {
	// 				state = Running;
	// 			}
	// 		case Running:
	// 			movement();
	// 	}
	// }

	function updateControls() {
		rightPressed = controls.right.check();
		leftPressed = controls.left.check();
		bothDirectionsPressed = leftPressed && rightPressed;
		singleDirectionPressed = leftPressed || rightPressed;
		noDirectionPressed = !singleDirectionPressed;
	}

	override function update(elapsed: Float) {
		movement();
		updateControls();
		super.update(elapsed);
	}
}