package characters;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

using echo.FlxEcho;
using utils.SpriteHelpers;

class LeafAnt extends FlxTypedGroup<FlxObject> {
  public var collisionListener: FlxObject;
  public var sprite: FlxSprite;
  final MOVEMENT_SPEED = 200;
  var potision: FlxPoint;
  var collisionXOffset: Float;
  var collisionYOffset: Float;
  // options
  public function new(options: LeafAntInputs) {
    super(2);
    potision = new FlxPoint(options.x, options.y);
    this.collisionXOffset = options.collisionXOffset;
    this.collisionYOffset = options.collisionYOffset;
    // 1 - sprite
    sprite = new FlxSprite(options.x, options.y);
    sprite.loadFrames(options.spriteSheet);
    sprite.setAnimationByFrames({
      name: "walking",
      totalFrames: 12,
      frameNamePrefix: options.framePrefix,
      frameRate: 8,
    });
    final startAnimFrame = Math.floor(Math.random() * 12);
    sprite.animation.play("walking", startAnimFrame);
    add(sprite);

    // 2 - collision
    collisionListener = new FlxObject(options.x, options.y + options.collisionYOffset, options.collisionWidth, 10);
    collisionListener.add_body({mass: 0});
    add(collisionListener);
  }

  public function resetPosition(shiftXBy: Int = 0) {
    trace(shiftXBy, "shiftXBy");
    sprite.setPosition(potision.x + shiftXBy, potision.y);
    collisionListener.setPosition(potision.x + shiftXBy, potision.y + collisionYOffset);
  }

  public function startMovement() {
    sprite.velocity.x = -MOVEMENT_SPEED;
  }

  public function disableCollision() {
    final collisionBody = collisionListener.get_body();
    collisionBody.active = false;
  }

  override function update(elapsed: Float) {
    if (true) {
      final collisionBody = collisionListener.get_body();
      collisionBody.x = sprite.x + collisionXOffset;
    }

    if (!this.alive) {
      sprite.setPosition(potision.x, potision.y);
      this.revive();
    }
    super.update(elapsed);
  }
}

typedef LeafAntInputs = {
  x: Float,
  y: Float,
  spriteSheet: String,
  framePrefix: String,
  collisionWidth: Float,
  collisionXOffset: Float,
  collisionYOffset: Float,
}