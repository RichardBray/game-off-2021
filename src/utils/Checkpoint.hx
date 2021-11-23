package utils;

import characters.Player;
import flixel.FlxObject;
import utils.GameDataStore;

using echo.FlxEcho;

class Checkpoint extends FlxObject {
  final dataStore = GameDataStore.instance;

  public function new(x: Int, y: Int, player: Player) {
    super(x, y, 50, 100);
    this.add_body({mass: 0});

    this.listen(player, {
      separate: false,
      enter: (_, _, _) -> dataStore.setPlayerPos(x, y)
    });
  }
}