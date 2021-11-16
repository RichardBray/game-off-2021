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
	static inline final RUNNING_JUMP_VELOCITY = 90;
	static inline final STANDING_JUMP_VELOCITY = 50;
	static inline final RUNNING_JUMP_AIRTIME_IN_SECONDS = 0.08;

	final controls = Controls.instance;
	public var state(default, null): PlayerStates = Standing;

	// - timers
	var runningJumpSeconds: Float = 0;
	var standingJumpPrepSeconds: Float = 0;
	var standingJumpSeconds: Float = 0;
	// - control button presses
	var rightPressed = false;
	var leftPressed = false;
	var jumpButtonPressed = false;
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
			totalFrames: 7,
			frameNamePrefix: "Girl_RunJump_",
			frameRate: 10,
		});
		this.setAnimationByFrames({
			name: "standingJump",
			totalFrames: 12,
			frameNamePrefix: "Girl_StandingJump_",
			frameRate: 12,
		});
		// - facing direction
		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
	}

	function stateMachine(elapsed: Float) {
		final physicsBody = this.get_body();
		final jumpTriggered = jumpButtonPressed && isTouching(FLOOR);
		switch(state) {
			case Standing:
				runningJumpSeconds = 0;
				standingJumpSeconds = 0;
				standingJumpPrepSeconds = 0;
				if (bothDirectionsPressed || noDirectionPressed) {
					physicsBody.velocity.x = 0;
					this.animation.play("standing");

					if (jumpTriggered) {
						state = StandingJump;
					}
				} else {
					state = Running;
				}
			case Running:
				if (bothDirectionsPressed || noDirectionPressed) {
					state = Standing;
				} else {
					physicsBody.velocity.x = rightPressed ? RUNNING_SPEED : -RUNNING_SPEED;
					this.facing = rightPressed ? FlxObject.RIGHT : FlxObject.LEFT;
					this.animation.play("running");

					if (jumpTriggered) {
						state = RunningJump;
					}
				}
			case RunningJump:
				runningJumpSeconds += elapsed;
				if (runningJumpSeconds < RUNNING_JUMP_AIRTIME_IN_SECONDS) {
					physicsBody.velocity.y -= RUNNING_JUMP_VELOCITY;
					this.animation.play("runningJump");
				} else if (isTouching(FLOOR)) {
					state = Standing;
				}
			case StandingJump:
				standingJumpSeconds += elapsed;
				if (standingJumpSeconds < 1.0) {
					this.animation.play("standingJump");
				} else if (standingJumpSeconds < 1.05) {
					this.animation.pause();
					physicsBody.velocity.y -= STANDING_JUMP_VELOCITY;
				} else if (isTouching(FLOOR)) {
					state = Standing;
				}
		}
	}

	function updateControls() {
		rightPressed = controls.right.check();
		leftPressed = controls.left.check();
		bothDirectionsPressed = leftPressed && rightPressed;
		singleDirectionPressed = leftPressed || rightPressed;
		noDirectionPressed = !singleDirectionPressed;
		jumpButtonPressed = controls.cross.check() || controls.up.check();
	}

	override function update(elapsed: Float) {
		updateControls();
		stateMachine(elapsed);
		super.update(elapsed);
	}
}