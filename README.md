# Game off 2021 entry

## Main Tools
- Haxe
- Lix
- HaxeFlixel
- Echo Physics

---
## Dev Notes

js.Browser.console.log();
js.Lib.Debug();
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
- Add left leve boundary
- Death animation
- Checkpoints
- Pause screen

## Post Jam changes
- Climb down ability
- Add shadow
- Roll animation for jumping off high points
- Increment deaths