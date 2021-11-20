package environment;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;
using flixel.util.FlxSpriteUtil;
using hxmath.math.Vector2;

typedef ClimeableSpriteOptions = {
  var x:Int;
  var y:Int;
  var imageName: String;
  var imageWidth: Int;
  var imageHeight: Int;
  var player: Player;
  var vertices: Array<Array<Int>>;
  var ?flipImageX: Bool;
}

class ClimableSprite extends FlxTypedGroup<FlxObject> {
  public function new(options: ClimeableSpriteOptions) {
    super(2);
    // 1 - image sprite
    final polygonVerts = [
      for (v in options.vertices) new Vector2(v[0] - ((options.imageWidth - 15) * 0.5), v[1] - ((options.imageHeight - 30) * 0.5))
    ];
    final sprtImage = new FlxSprite(options.x, options.y);
    sprtImage.loadGraphic(
      'assets/images/environment/${options.imageName}.png',
      false,
      options.imageWidth,
      options.imageHeight
    );
		sprtImage.setFacingFlip(FlxObject.LEFT, true, false);
		sprtImage.setFacingFlip(FlxObject.RIGHT, false, false);
    if (options.flipImageX) {
      sprtImage.facing = FlxObject.LEFT;
    }
    sprtImage.add_body({
      mass: 0,
      shape: {
        type: POLYGON,
        vertices: polygonVerts,
      }
    });
    add(sprtImage);
    // 2 - listener
    final climableListener = new FlxObject(options.x, options.y + (options.imageHeight / 2), options.imageWidth, 90);
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