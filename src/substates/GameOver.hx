package substates;

import flixel.FlxSubState;
import flixel.text.FlxText;
import utils.Colors;

final class GameOver extends FlxSubState {
  public function new(playDeathAnim: Bool = false) {
    super(Colors.black);
    final text = new FlxText(0, 0, 0, "You died", 48);
    text.scrollFactor.set(0, 0);
    text.screenCenter(XY);
    add(text);
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);

    if (true) close();
  }
}