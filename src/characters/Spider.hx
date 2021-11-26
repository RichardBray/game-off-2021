package characters;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;
using utils.SpriteHelpers;

class Spider extends FlxTypedGroup<FlxObject> {
  public var startSpiderMovement: Bool = false;
  public var sprite: FlxSprite;
  var collisionListener: FlxObject;
  var spiderMovementTimer: Float = 0;
  var player:Player;

  public function new(x: Float = 0, y: Float = 0, player: Player) {
    super(2);
    this.player = player;
    // 1 - sprite
    sprite = new FlxSprite(x, y);
    sprite.loadFrames("characters/spider");

		sprite.setFacingFlip(FlxObject.LEFT, true, false);
		sprite.setFacingFlip(FlxObject.RIGHT, false, false);
    sprite.facing = FlxObject.LEFT;
    sprite.add_body();
    sprite.setAnimationByFrames({
      name: "walking",
      totalFrames: 12,
      frameNamePrefix: "GiantSpider-",
      frameRate: 8,
    });
    sprite.animation.play("walking");
    add(sprite);

    // 2 - collision
    collisionListener = new FlxObject(x + 747, y + 680, 95, 74);
    collisionListener.add_body({mass: 0});
    add(collisionListener);


    // listeners

    collisionListener.listen(player, {
      separate: false,
      enter: (_, _, _) -> player.startDeathSequence = true,
    });

    sprite.listen(player, {
      separate: false,
    });
  }

  function spiderMovement(elapsed: Float) {
    final spriteBody = sprite.get_body();
    final collisionBody = collisionListener.get_body();
    spiderMovementTimer += elapsed;

    spriteBody.velocity.x = -200;
    collisionBody.x = spriteBody.x;
  }

	override function update(elapsed: Float) {
    if (startSpiderMovement) {
      spiderMovement(elapsed);
    }
		super.update(elapsed);
	}
}