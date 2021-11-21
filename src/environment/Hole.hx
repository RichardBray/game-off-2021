package environment;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.Colors;
import utils.GameDataStore;

using echo.FlxEcho;

class Hole extends FlxTypedGroup<FlxObject> {
  final dataStore = GameDataStore.instance;

  public function new(x: Float, y: Float, player: Player) {
    super(2);

    // 1- listener
    final listener = new FlxObject((x + 5), (y - 23), 40, 23);
    listener.add_body({mass: 0});
    add(listener);

    // 2 - sprite
    final hole = new FlxSprite(x, y).makeGraphic(50, 7, Colors.black);
    add(hole);

		player.listen(listener, {
			separate: false,
			enter: (playerBody, _listenerBody, _) -> dataStore.data.enableGroundListener = false,
		});
  }
}