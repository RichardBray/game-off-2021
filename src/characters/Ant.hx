package characters;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;

using echo.FlxEcho;
using utils.SpriteHelpers;

class Ant extends FlxSprite {
  public var state: AntStates = Standing;
  public var returnFromMushroomTriggered: Bool = false;
  var player: Player;

  var returnFromMushroomTimer: Float = 0;

  public function new(x: Float = 0, y: Float = 0, player: Player) {
    super(x, y);
    this.player = player;
    this.loadFrames("characters/ant");
		this.changeHitboxSize({
			reduceWidthBy: 150,
			reduceHeightBy: 100,
      heightOffset: 50,
      widthOffset: 10,
		});
    this.setAnimationByFrames({
      name: "running",
      totalFrames: 11,
      frameNamePrefix: "Ant_Run-",
      frameRate: 17,
    });
    this.setAnimationByFrames({
      name: "attacking",
      totalFrames: 17,
      frameNamePrefix: "Ant_Attack_",
      frameRate: 12,
    });

    this.add_body();

		// - facing directions
		this.setFacingFlip(FlxObject.LEFT, true, false);
		this.setFacingFlip(FlxObject.RIGHT, false, false);
  }

  function stateMachine() {
    final physicsBody = this.get_body();
    final RUNNING_SPEED = 400;
    switch(state) {
      case RunningRight:
        physicsBody.velocity.x = RUNNING_SPEED;
        this.animation.play("running");
      case RunningLeft:
        physicsBody.velocity.x = -RUNNING_SPEED;
        this.facing = FlxObject.LEFT;
        this.animation.play("running");
      case Attacking:
        physicsBody.velocity.x = 0;
        this.facing = FlxObject.LEFT;
        this.animation.play("attacking");
      case Standing:
        physicsBody.velocity.x = 0;
        this.animation.pause();
    }
  }

  function attackPlayer() {
    this.listen(player, {
      separate: false,
      enter: (_, _, _) -> {
        state = Attacking;
        player.deathSequence();
      },
    });
  }

  function returnFromMushroom(elapsed: Float) {
    returnFromMushroomTimer += elapsed;
    if (returnFromMushroomTimer > .1) {
      this.state = Standing;
    }
    if (returnFromMushroomTimer > 1) {
      this.state = RunningLeft;
    }
    if (returnFromMushroomTimer > 6) {
      this.state = Standing;
      returnFromMushroomTimer = 0;
    }
  }

	override function update(elapsed: Float) {
		stateMachine();
    attackPlayer();

    if (returnFromMushroomTriggered) {
      returnFromMushroom(elapsed);
    }
		super.update(elapsed);
	}
}

enum AntStates {
  RunningRight;
  RunningLeft;
  Attacking;
  Standing;
}