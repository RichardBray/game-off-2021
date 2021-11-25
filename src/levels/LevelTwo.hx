package levels;

import characters.Ant;
import characters.Player;
import characters.PlayerClimb;
import characters.Wasp;
import environment.Hole;
import environment.MovableSprite;
import environment.Mushrooms;
import environment.Pebbles;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import openfl.filters.ShaderFilter;
import shaders.Pixelate;
import states.GameState;
import ui.TextPrompts;
import utils.Checkpoints;
import utils.Colors;
import utils.GameDataStore;

using echo.FlxEcho;
using hxmath.math.Vector2;
final class LevelTwo extends GameState {
	final dataStore = GameDataStore.instance;
	var player: Player;
	var groundListener: FlxObject;
	var cameraUpTrigger: FlxObject;
	var cameraDownTrigger: FlxObject;
	var wasp: Wasp;

	// - triggers set
	var cameraUpSet: Bool = false;
	var cameraDownSet: Bool = false;

	override function create() {
		super.create();
		final fullMapWidth = FlxG.width * 6;

		// - physics world
		FlxEcho.init({
			width: fullMapWidth,
			height: FlxG.height,
			gravity_y: 960,
		});
		// - background sprites
		final BG_SPRITE_WIDTH = 2353;
		final BG_SPRITE_HEIGHT = 1885;
		final totalBackgroundSprites = Math.ceil(fullMapWidth / BG_SPRITE_WIDTH);
		final grpBackground = new FlxTypedGroup<FlxSprite>(totalBackgroundSprites);

		for (backgroundSprite in 0...totalBackgroundSprites) {
			final xPos = BG_SPRITE_WIDTH * backgroundSprite;
			final background = new FlxSprite(xPos, -641);
			background.loadGraphic(
				"assets/images/environment/grassTile.png",
				BG_SPRITE_WIDTH, BG_SPRITE_HEIGHT
			);
			grpBackground.add(background);
		}

		// - midground sprite
		final GROUND_HEIGHT_FROM_BASE = 244;
		groundListener = new FlxObject(
			0,
			FlxG.height - GROUND_HEIGHT_FROM_BASE,
			fullMapWidth,
			GROUND_HEIGHT_FROM_BASE
		);
		groundListener.add_body({mass: 0});

		// - player sprites
		final playerClimb = new PlayerClimb();
		player = new Player(dataStore.data.playerPos.x, dataStore.data.playerPos.y, playerClimb);

		// - npc sprites
		final ant = new Ant(3989, 675, player);
		wasp = new Wasp(5760, 0);
		wasp.alpha = 0;
		wasp.scale.set(.5, .5);

		// - invisible objects
		final leftBound = new FlxObject(0, 663, 35, 167);
		leftBound.add_body({mass: 0});
		final checkpoints = new Checkpoints(player);
		final antTrigger = new FlxObject(5000, 726, 49, 106);
		antTrigger.add_body({mass: 0});
		cameraUpTrigger = new FlxObject(6746, 726, 49, 106);
		cameraUpTrigger.add_body({mass: 0});
		cameraDownTrigger = new FlxObject(8598, 726, 49, 106);
		cameraDownTrigger.add_body({mass: 0});

		// - environments objects
		final pebbles = new Pebbles(player);
		final hole = new Hole(1721, 828, player);
		final holeCovering = new FlxSprite((hole.x - 8), (FlxG.height - GROUND_HEIGHT_FROM_BASE + 9));
		holeCovering.makeGraphic(137, GROUND_HEIGHT_FROM_BASE, Colors.groundGreen);
		final movableRock = new MovableSprite({
			x: 2969,
			y: 728,
			player: player,
			groundListener: groundListener,
		});
		final mushrooms = new Mushrooms(player);
		final raisedPlatform = new FlxSprite(3647, 617).makeGraphic(800, 218, Colors.groundGreen);
		raisedPlatform.add_body({ mass: 0 });

		// - help text
		// final textPropmpts = new TextPrompts(player);

		// - order objects
		this.add(leftBound);
		this.add(antTrigger);
		this.add(cameraUpTrigger);
		this.add(cameraDownTrigger);
		this.add(checkpoints);
		this.add(grpBackground);
		this.add(groundListener);

		this.add(pebbles);
		this.add(hole);
		this.add(movableRock);
		this.add(mushrooms);

		this.add(ant);
		this.add(wasp);
		this.add(raisedPlatform);
		this.add(playerClimb);
		this.add(player);
		this.add(holeCovering);
		// add(textPropmpts);

		// - physics listeners
		player.listen(leftBound);
		player.listen(groundListener);
		player.listen(raisedPlatform);

		ant.listen(groundListener);

		final test = mushrooms.members[0];
		movableRock.sprite.listen(test.stalkCollision);

		antTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> ant.state = Running,
		});

		// - camera settings
		FlxG.worldBounds.set(0, 0, fullMapWidth, FlxG.height);
		FlxG.camera.setScrollBoundsRect(0, 0, fullMapWidth, FlxG.height);
		FlxG.camera.follow(player);
		FlxG.camera.deadzone = FlxRect.get(
			((FlxG.camera.width - (player.width)) / 2) - 300,
			((FlxG.camera.height - player.height) / 2),
			player.width,
			player.height
		);

		if (false) { // TODO add pixelation menu option
			var effect = new Pixelate();
			FlxG.camera.setFilters([new ShaderFilter(cast effect)]);
		}
	}

	function levelResetConditions() {
		groundListener.get_body().active = dataStore.data.enableGroundListener;
		final playerBelowGround = player.get_body().y > FlxG.height;
		if (playerBelowGround || !player.alive) {
			dataStore.data.enableGroundListener = true;
			FlxG.resetState();
		}
	}

	function cameraMovements(elapsed: Float) {
		cameraUpTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				if (!cameraUpSet) {
					FlxTween.tween(FlxG.camera, {height: FlxG.camera.height + 200}, 1);
					FlxTween.tween(FlxG.camera, {zoom: .8}, 1);
					wasp.triggerSkyFly = true;
					cameraUpSet = true;
				}
			}
		});
		cameraDownTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				if (!cameraDownSet) {
					FlxTween.tween(FlxG.camera, {height: FlxG.camera.height - 200}, 1);
					FlxTween.tween(FlxG.camera, {zoom: 1}, 1);
					cameraDownSet = true;
				}
			}
		});
	}

	override function update(elapsed: Float) {
		levelResetConditions();
		cameraMovements(elapsed);
		super.update(elapsed);
	}
}
