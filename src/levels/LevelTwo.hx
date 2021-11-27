package levels;

import characters.Ant;
import characters.LeafAntGrp;
import characters.Player;
import characters.PlayerClimb;
import characters.Spider;
import characters.Wasp;
import environment.Hole;
import environment.MovableSprite;
import environment.Mushrooms;
import environment.Pebbles;
import environment.PlantStem;
import environment.TreeStump;
import environment.TreeStumpCover;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import openfl.filters.ShaderFilter;
import shaders.Pixelate;
import states.GameState;
import ui.TextPrompts;
import utils.Checkpoints;
import utils.Colors;
import utils.GameDataStore;

using echo.FlxEcho;
using flixel.tweens.FlxTween;
using hxmath.math.Vector2;

final class LevelTwo extends GameState {
	final dataStore = GameDataStore.instance;
	var player: Player;
	var groundListener: FlxObject;
	var waspFlyByTrigger: FlxObject;
	var antReturnTrigger: FlxObject;
	var spiderMovementTrigger: FlxObject;
	var antTrigger: FlxObject;
	var wasp: Wasp;
	var cameraUpTrigger: FlxObject;
	var cameraDownTrigger: FlxObject;

	// - triggers set
	var cameraUpSet: Bool = false;
	var cameraDownSet: Bool = false;

	override function create() {
		super.create();
		final fullMapWidth = FlxG.width * 9;

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
		final ant = new Ant(3789, 685, player);
		wasp = new Wasp(5760, 0);
		wasp.alpha = 0;
		final spider = new Spider(10292, -450, player); // 11292
		final leafAntGroup = new LeafAntGrp(14505, 249, player);

		// - invisible objects
		final leftBound = new FlxObject(0, 663, 35, 167);
		leftBound.add_body({mass: 0});
		final checkpoints = new Checkpoints(player);

		antTrigger = new FlxObject(4580, 726, 49, 106);
		antTrigger.add_body({mass: 0});
		antReturnTrigger = new FlxObject(6244, 726, 49, 106);
		antReturnTrigger.add_body({mass: 0});

		waspFlyByTrigger = new FlxObject(6746, 726, 49, 106);
		waspFlyByTrigger.add_body({mass: 0});

		spiderMovementTrigger = new FlxObject(8817, 729, 49, 106);
		spiderMovementTrigger.add_body({mass: 0});

		cameraUpTrigger = new FlxObject(11076, 58, 49, 106);
		cameraUpTrigger.add_body({mass: 0});
		cameraDownTrigger = new FlxObject(8598, 58, 49, 106);
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
		final plantStem = new PlantStem(3300, -565, player);
		final treeStump = new TreeStump(11108, 164, player);
		final treeStumpCover = new TreeStumpCover(10700, 130);

		// - help text
		// final textPropmpts = new TextPrompts(player);

		// - order objects
		add(leftBound);
		add(antTrigger);
		add(cameraUpTrigger);
		add(cameraDownTrigger);
		add(antReturnTrigger);
		add(waspFlyByTrigger);
		add(spiderMovementTrigger);
		add(wasp);
		add(checkpoints);
		add(grpBackground);
		add(groundListener);

		add(treeStump);
		add(leafAntGroup);
		add(treeStumpCover);
		add(pebbles);
		add(hole);
		add(movableRock);
		add(ant);
		add(plantStem);
		add(spider);
		add(mushrooms);

		add(playerClimb);
		add(player);
		add(holeCovering);
		// add(textPropmpts);

		// - physics listeners
		groundListener.listen(player);
		groundListener.listen(spider.sprite);
		leftBound.listen(player);

		ant.listen(groundListener);
		movableRock.sprite.listen(mushrooms.members[0].stalkCollision);

		antTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> ant.state = RunningRight,
		});

		antReturnTrigger.listen(ant, {
			separate: false,
			enter: (_, _, _) -> ant.returnFromMushroomTriggered = true,
		});

		waspFlyByTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> wasp.triggerSkyFly = true,
		});

		spiderMovementTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> spider.startSpiderMovement = true,
		});

		checkpoints.members[2].listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				spider.kill();
				spider.collisionListener.get_body().active = false;
			},
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

	function cameraMovements() {
		cameraUpTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				if (!cameraUpSet) {
					FlxG.camera.tween({height: FlxG.camera.height + 200}, 1);
					cameraUpSet = true;
				}
			}
		});
		cameraDownTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				if (!cameraDownSet) {
					FlxG.camera.tween({height: FlxG.camera.height - 200}, 1);
					cameraDownSet = true;
				}
			}
		});
	}

	override function update(elapsed: Float) {
		levelResetConditions();
		cameraMovements();
		super.update(elapsed);
	}
}
