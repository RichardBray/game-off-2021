package characters;

import flixel.FlxSprite;

import utils.Colors;
import utils.Controls;

using echo.FlxEcho;class Player extends FlxSprite {
	final controls = Controls.instance;

	public function new(x: Float = 0, y: Float = 0) {
		super(x, y);
		makeGraphic(100, 350, Colors.purple);

		this.add_body();
	}

	function movement() {
		final body = this.get_body();
		body.velocity.x = 0;
		if (controls.left.check()) body.velocity.x -= 128;
		if (controls.right.check()) body.velocity.x += 128;
		if (controls.cross.check() && isTouching(FLOOR)) body.velocity.y -= 256;
	}

	override function update(elapsed: Float) {
		movement();
		super.update(elapsed);
	}
}