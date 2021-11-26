package environment;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;
using hxmath.math.Vector2;

class PlantStem extends FlxTypedGroup<FlxObject> {

  final vertices:Array<Array<Float>> = [
    [0, 0],
    [36, -99],
    [90, -148.5],
    [170.5, -189],
    [240, -204],
    [315, -197.5],
    [383, -171.5],
    [410.5, -148.5]
  ];
  var sprite:FlxSprite;
  public var leafCollision: FlxObject;
  public function new(x: Float = 0, y: Float = 0) {
    super(2);

    // 1 - sprite
    sprite = new FlxSprite(x, y).loadGraphic("assets/images/environment/PlantStem.png", false, 763, 1395);
    add(sprite);

    // 2 - leaf collision
    leafCollision = new FlxObject(x + 763, y + 1195, 411, 204);
    final collisionOffsetX = 850;
    final collisionOffsetY = -380;
    final test = new Vector2(50, 50);
    final polygonVerts = [
      for (v in vertices) new Vector2(v[0] - ((leafCollision.width + collisionOffsetX) * 0.5), v[1] - ((leafCollision.height + collisionOffsetY) * 0.5))
    ];
    leafCollision.add_body({
      mass: 0,
      drag_length: 5000,
      shape: {
        type: POLYGON,
        vertices: polygonVerts,
      }
    });
    add(leafCollision);
  }
}