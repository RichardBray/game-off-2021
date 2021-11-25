package environment;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;
using flixel.util.FlxSpriteUtil;
using hxmath.math.Vector2;
using utils.SpriteHelpers;


class ClimableSprite extends FlxTypedGroup<FlxObject> {
  public var sprtImage: FlxSprite;

  public function new(options: ClimeableSpriteOptions) {
    super(2);
    // 1 - image sprite
    final polygonVerts = [
      for (v in options.vertices) new Vector2(v[0] - ((options.imageWidth + options.collisionOffsetX) * 0.5), v[1] - ((options.imageHeight + options.collisionOffsetY) * 0.5))
    ];
    sprtImage = new FlxSprite(options.x, options.y);
    sprtImage.loadFrames(options.spriteSheet);
    sprtImage.animation.frameName = options.frameName;
    sprtImage.width = options.imageWidth;
    sprtImage.height = options.imageHeight;

    sprtImage.add_body({
      mass: 0,
      shape: {
        type: POLYGON,
        vertices: polygonVerts,
      }
    });
    add(sprtImage);
    // 2 - listener
    final climableListener = new FlxObject(options.x + options.climeableTriggerOffsetX, options.y + options.climeableTriggerOffsetY, options.imageWidth, 90);
    climableListener.add_body({mass: 0});
    add(climableListener);

    // physics listeners
    options.player.listen(sprtImage);
		options.player.listen(climableListener, {
			separate: false,
			enter: (_playerBody, _ledgeListenerBody, _) -> options.player.allowClimb = true,
			exit: (_playerBody, _ledgeListenerBody) -> options.player.allowClimb = false,
		});
  }
}

typedef ClimeableSpriteOptions = {
  var x:Int;
  var y:Int;
  var imageWidth: Int;
  var imageHeight: Int;
  var player: Player;
  var vertices: Array<Array<Float>>;
  var spriteSheet: String;
  var frameName: String;
  var collisionOffsetX: Int;
  var collisionOffsetY: Int;
  var climeableTriggerOffsetY: Float;
  var climeableTriggerOffsetX: Float;
}