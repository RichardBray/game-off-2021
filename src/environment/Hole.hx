package environment;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.Colors;
import utils.GameDataStore;

using echo.FlxEcho;
using utils.SpriteHelpers;

class Hole extends FlxTypedGroup<FlxObject> {
  final dataStore = GameDataStore.instance;
  var player: Player;
  public var x:Float;

  public function new(x: Float, y: Float, player: Player) {
    super(2);
    this.player = player;
    this.x = x;
    // 1- listener
    final listener = new FlxObject((x + 56), (y - 10), 10, 10);
    listener.add_body({mass: 0});
    this.add(listener);

    // 2 - sprite
    final hole = new FlxSprite(x, y);
    hole.width = 122.5;
    hole.height = 16;
		hole.loadFrames("environment/items");
		hole.animation.frameName = "Hole_01.png";
    this.add(hole);

		this.player.listen(listener, {
			separate: false,
			stay: preventGroundCollisions
		});
  }

  function preventGroundCollisions(playerBody, _listenerBody, _) {
    dataStore.data.enableGroundListener = false;
    this.player.freeze();
  }
}