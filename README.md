# Game off 2021 entry

## Main Tools
- Haxe
- Lix
- HaxeFlixel
- Echo Physics

---
## Dev Notes
### Installing Echo-Flixel with Lix
```
lix install gh:AustinEast/echo-flixel
```

### Adjusting player deadzone helper
```hx
		final deadZone = new FlxSprite(((FlxG.camera.width - (player.width)) / 2) - 200, ((FlxG.camera.height - player.height) / 2 - player.height * 0.25)).makeGraphic(Std.int(player.width), Std.int(player.height), 0xFF000000);
		add(deadZone);
```

## Todo
- Prevent looping running jump animtion on large jumps
- Update character hitbox for tighter collisions when pushing/climbing

## Post Jam changes
- Climb down ability
- Fix anim flash after climb