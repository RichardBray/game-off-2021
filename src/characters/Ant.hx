package characters;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;

using echo.FlxEcho;
using utils.SpriteHelpers;

class Ant extends FlxSprite {
  public var state: AntStates = Standing;
  var player: Player;

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
      frameRate: 15,
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
    switch(state) {
      case Running:
        physicsBody.velocity.x = 500;
        this.animation.play("running");
      case Attacking:
        physicsBody.velocity.x = 0;
        this.facing = FlxObject.LEFT;
        this.animation.play("attacking");
      case Standing:
        physicsBody.velocity.x = 0;
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

	override function update(elapsed: Float) {
		stateMachine();
    attackPlayer();
		super.update(elapsed);
	}
}

enum AntStates {
  Running;
  Attacking;
  Standing;
}