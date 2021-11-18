package characters;

import flixel.FlxObject;
import flixel.FlxSprite;
import utils.Controls;

using echo.FlxEcho;
using utils.SpriteHelpers;


enum PlayerStates {
	Running;
	Standing;
	RunningJump;
	StandingJump;
	StandingJumpFail;
	Climbing;
}

class Player extends FlxSprite {
	static inline final RUNNING_SPEED = 350;
	static inline final RUNNING_JUMP_VELOCITY = 90;
	static inline final STANDING_JUMP_VELOCITY = 65;

	final controls = Controls.instance;
	public var state(default, null): PlayerStates = Standing;
	/**
	 * Trigger to decide if player should clime or fail jump
	 */
	public var allowClimb = false;

	var climbAnim: PlayerClimb;
	var postClimbPositionSet = false;
	// - timers
	var runningJumpSeconds: Float = 0;
	var climbingSeconds: Float = 0;
	var standingJumpSeconds: Float = 0;
	// - control button presses
	var rightPressed = false;
	var leftPressed = false;
	var jumpButtonPressed = false;
	var bothDirectionsPressed = false;
	var singleDirectionPressed = false;
	var noDirectionPressed = false;

	/**
	 * @param x
	 * @param y
	 * @param playerClimb Hack to prevent jankiness when player climbs ledge
	 */
	public function new(x: Float = 0, y: Float = 0, playerClimb: PlayerClimb) {
		super(x, y);
		climbAnim = playerClimb;
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
			startFrame: 6,
		});
		this.setAnimationByFrames({
			name: "standingJumpFail",
			totalFrames: 6,
			frameNamePrefix: "Girl_JumpFail_",
			frameRate: 12,
		});
		// - facing direction
		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
	}

	function setPlayerDefaults() {
		runningJumpSeconds = 0;
		standingJumpSeconds = 0;
		climbingSeconds = 0;
		this.alpha = 1;
		postClimbPositionSet = false;
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
				final RUNNING_JUMP_AIRTIME_IN_SECONDS = .08;
				runningJumpSeconds += elapsed;
				if (runningJumpSeconds < RUNNING_JUMP_AIRTIME_IN_SECONDS) {
					physicsBody.velocity.y -= RUNNING_JUMP_VELOCITY;
					this.animation.play("runningJump");
				} else if (isTouching(FLOOR)) {
					state = Standing;
				}
			case StandingJump:
				final STANDING_JUMP_PREPTIME = .45;
				final STANDING_JUMP_ANIM_FINISH = STANDING_JUMP_PREPTIME + .05;
				final STANDING_JUMP_TRANSITION_ANIM = STANDING_JUMP_ANIM_FINISH + .1;
				standingJumpSeconds += elapsed;
				if (standingJumpSeconds < STANDING_JUMP_PREPTIME) {
					this.animation.play("standingJump");
				} else if (standingJumpSeconds < STANDING_JUMP_ANIM_FINISH) {
					this.animation.pause();
					physicsBody.velocity.y -= STANDING_JUMP_VELOCITY;
				} else if (standingJumpSeconds < STANDING_JUMP_TRANSITION_ANIM) {
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
				climbingSeconds += elapsed;
				this.alpha = 0;
				climbAnim.startClimb(this);
				if (climbingSeconds < .1) {
					physicsBody.active = false;
				}
				if (climbingSeconds > .1 && !postClimbPositionSet ) {
					physicsBody.x = this.facing == FlxObject.RIGHT ? physicsBody.x + 67 : physicsBody.x - 67;
					physicsBody.y = physicsBody.y - 207;
					physicsBody.active = true;
					postClimbPositionSet = true;
				}
				if (climbingSeconds > .925) {
					allowClimb = false;
					climbAnim.endClimb();
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