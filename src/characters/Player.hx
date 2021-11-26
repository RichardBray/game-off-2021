package characters;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import utils.Controls;

using echo.FlxEcho;
using flixel.tweens.FlxTween;
using utils.SpriteHelpers;

class Player extends FlxSprite {
	final controls = Controls.instance;
	public var state(default, null): PlayerStates = Standing;
	/**
	 * Trigger to decide if player should clime or fail jump
	 */
	public var allowClimb = false;
	public var inPushableTrigger = false;

	var jumpVelocitySet = false;

	// - climb vars
	var climbAnim: PlayerClimb;
	var climbPositionSet = false;
	var noPosAfterClimb: FlxPoint;
	// - timers
	var runningJumpTimer: Float = 0;
	var climbingTimer: Float = 0;
	var standingJumpTimer: Float = 0;
	var dyingTimer: Float = 0;
	// - button press booleans
	var rightPressed = false;
	var leftPressed = false;
	var jumpButtonPressed = false;
	var bothDirectionsPressed = false;
	var singleDirectionPressed = false;
	var noDirectionPressed = false;
	var actionBtnPressed = false;


	/**
	 * Hack to delay registering of controls
	 */
	 var sameButtonPressed = false;

	/**
	 * @param x
	 * @param y
	 * @param playerClimb Hack to prevent jankiness when player climbs ledge
	 */
	public function new(x: Float = 0, y: Float = 0, playerClimb: PlayerClimb) {
		super(x, y);

		noPosAfterClimb = new FlxPoint(0, 0);
		climbAnim = playerClimb;
		this.loadFrames("characters/girl");
		this.changeHitboxSize({
			reduceWidthBy: 150,
			reduceHeightBy: 200,
			heightOffset: 95,
			widthOffset: -1,
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
			startFrame: 6,
		});
		this.setAnimationByFrames({
			name: "standingJumpFail",
			totalFrames: 6,
			frameNamePrefix: "Girl_JumpFail_",
			frameRate: 12,
		});
		this.setAnimationByFrames({
			name: "pushing",
			totalFrames: 8,
			frameNamePrefix: "Girl_Push_",
			frameRate: 10,
		});
		this.setAnimationByFrames({
			name: "dying",
			totalFrames: 4,
			frameNamePrefix: "Girl_Death_",
			frameRate: 4,
		});
		// - facing directions
		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
	}

	function setPlayerDefaults() {
		runningJumpTimer = 0;
		standingJumpTimer = 0;
		climbingTimer = 0;
		this.alpha = 1;
		climbPositionSet = false;
		jumpVelocitySet = false;
	}

	function stateMachine(elapsed: Float) {
		final physicsBody = this.get_body();
		final jumpTriggered = jumpButtonPressed && isTouching(FLOOR);

		switch(state) {
			case Standing:
				setPlayerDefaults();
				if (bothDirectionsPressed || noDirectionPressed) {
					physicsBody.velocity.x = 0;
					this.animation.play("standing");

					if (jumpTriggered) {
						state = StandingJump;
					}
				} else {
					state = Running;
				}
				if (actionBtnPressed) {
					if (inPushableTrigger && !sameButtonPressed) {
						state = PushingPose;
						haxe.Timer.delay(() -> sameButtonPressed = true, 250);
					}
				}
			case Running:
				final RUNNING_SPEED = 350;

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
				if (actionBtnPressed) {
					if (inPushableTrigger && !sameButtonPressed) {
						state = PushingPose;
						haxe.Timer.delay(() -> sameButtonPressed = true, 250);
					}
				}
			case RunningJump:
				final RUNNING_JUMP_VELOCITY = 290;
				final RUNNING_JUMP_ANIM_RUNTIME = .7;

				runningJumpTimer += elapsed;
				this.animation.play("runningJump");
				if (!jumpVelocitySet) {
					physicsBody.velocity.y = -RUNNING_JUMP_VELOCITY;
					jumpVelocitySet = true;
				}

				if (runningJumpTimer > RUNNING_JUMP_ANIM_RUNTIME) {
					this.animation.pause();
					if (isTouching(FLOOR)) {
						state = Standing;
					}
				}

			case StandingJump:
				final STANDING_JUMP_VELOCITY = 65;
				final STANDING_JUMP_PREPTIME = .45;
				final STANDING_JUMP_ANIM_FINISH = STANDING_JUMP_PREPTIME + .05;
				final STANDING_JUMP_TRANSITION_ANIM = STANDING_JUMP_ANIM_FINISH + .1;

				standingJumpTimer += elapsed;
				if (standingJumpTimer < STANDING_JUMP_PREPTIME) {
					this.animation.play("standingJump");
				} else if (standingJumpTimer < STANDING_JUMP_ANIM_FINISH) {
					this.animation.pause();
					physicsBody.velocity.y -= STANDING_JUMP_VELOCITY;
				} else if (standingJumpTimer < STANDING_JUMP_TRANSITION_ANIM) {
					if (allowClimb) {
						state = Climbing;
					} else {
						state = StandingJumpFail;
					}
				}
			case StandingJumpFail:
				this.animation.play("standingJumpFail");
				if (isTouching(FLOOR)) {
					allowClimb = false;
					state = Standing;
				}
			case Climbing:
				climbingTimer += elapsed;
				this.alpha = 0;
				climbAnim.startClimb(this);
				if (climbingTimer < .1) {
					physicsBody.active = false;
				}
				if (climbingTimer > .1 && !climbPositionSet ) {
					noPosAfterClimb.x = this.facing == FlxObject.RIGHT ? physicsBody.x + 50 : physicsBody.x - 50;
					noPosAfterClimb.y = physicsBody.y - 207;
					climbPositionSet = true;
				}
				if (climbingTimer > .15) {
					physicsBody.tween({x: noPosAfterClimb.x, y: noPosAfterClimb.y}, .1);
				}
				if (climbingTimer > .25) {
					physicsBody.active = true;
				}
				if (climbingTimer > .925) {
					allowClimb = false;
					climbAnim.endClimb();
					noPosAfterClimb.set(0, 0);
					state = Standing;
				}
			case Frozen:
				physicsBody.velocity.x = 0;
				this.animation.play("standing");
			case PushingPose:
				if (bothDirectionsPressed || noDirectionPressed) {
					physicsBody.velocity.x = 0;
					this.animation.play("pushing");
					this.animation.pause();
				} else if (facing == FlxObject.RIGHT && rightPressed || facing == FlxObject.LEFT && leftPressed) {
					state = Pushing;
				} else {
					state = Standing;
					haxe.Timer.delay(() -> sameButtonPressed = false, 250);
				}
				if (actionBtnPressed && sameButtonPressed) {
					state = Standing;
					haxe.Timer.delay(() -> sameButtonPressed = false, 250);
				}
			case Pushing:
				final PUSHING_SPEED = 250;

				if (bothDirectionsPressed || noDirectionPressed) {
					state = PushingPose;
				} else {
					physicsBody.velocity.x = PUSHING_SPEED;
					this.animation.play("pushing");
				}
			case Dying:
				dyingTimer += elapsed;
				physicsBody.velocity.x = 0;
				this.animation.play("dying");
		}
	}

	public function deathSequence() {
		trace(state, dyingTimer, 'slump');
		state = Dying;
		if (dyingTimer > .75) {
			this.kill();
			dyingTimer = 0;
		}
	}

	function updateControls() {
		rightPressed = controls.right.check();
		leftPressed = controls.left.check();
		bothDirectionsPressed = leftPressed && rightPressed;
		singleDirectionPressed = leftPressed || rightPressed;
		noDirectionPressed = !singleDirectionPressed;
		jumpButtonPressed = controls.cross.check() || controls.up.check();
		actionBtnPressed = controls.circle.check();
	}

	public function freeze() {
		state = Frozen;
	}

	override function update(elapsed: Float) {
		updateControls();
		stateMachine(elapsed);
		super.update(elapsed);
	}
}

enum PlayerStates {
	Running;
	Standing;
	RunningJump;
	StandingJump;
	StandingJumpFail;
	Climbing;
	Frozen;
	PushingPose;
	Pushing;
	Dying;
}
