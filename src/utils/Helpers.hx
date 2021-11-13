package utils;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

typedef SetAnimationOptions = {
  /**
   * Defines the name of the animation
   */
  var name:String;

  var totalFrames:Int;
  var frameNamePrefix:String;
  var frameRate:Int;
}

typedef ChangeHitBoxOptions = {
  /**
   * Amount to reduce hitbox WIDTH by in pixels
   */
	var reduceWidthBy: Int;
  /**
   * Amount to reduce hitbox HEIGHT by in pixels
   */
	var reduceHeightBy: Int;
	var ?heightOffset:Int;
	var ?widthOffset:Int;
}

final class Helpers {
  public static function setAnimationByFrames(sprite:FlxSprite, options:SetAnimationOptions) {
    sprite.animation.addByNames(options.name, Helpers.getAnimationFrames(options.totalFrames, options.frameNamePrefix), options.frameRate);
  }

  /**
   * Frame names used for sprite atlas animation.
	 * For this to work frame image names need to follow this format: <Prefix>05 or <Prefix>20 for nubmers above 10.
   *
   * @param noOfFrames frames used in animation
   * @param frameNamePrefix frame image name as stated in data file
   */
  private static function getAnimationFrames(noOfFrames:Int, frameNamePrefix:String):Array<String> {
    var frameNames:Array<String> = [];

    for (frameNo in 1...(noOfFrames + 1)) {
      final addLeadingZero = (frameNo < 10) ? ('0$frameNo') : '$frameNo';
      frameNames.push('${frameNamePrefix}${addLeadingZero}.png');
    }

    return frameNames;
  }

  /**
   * Method to change the site of a sprite's hitbox size.
   */
  public static function changeHitboxSize(sprite:FlxSprite, options:ChangeHitBoxOptions) {
    final newHitboxWidth:Int = Std.int(sprite.width - options.reduceWidthBy);
    final newHitboxHeight:Int = Std.int(sprite.height - options.reduceHeightBy);

    var offsetWidth:Float = options.reduceWidthBy / 2;
    var offsetHeight:Float = options.reduceHeightBy;

    if (options.widthOffset != null) offsetWidth = options.widthOffset;

    if (options.heightOffset != null) offsetHeight = options.heightOffset;

    sprite.setGraphicSize(newHitboxWidth, newHitboxHeight);
    sprite.updateHitbox();
    sprite.offset.set(offsetWidth, offsetHeight);
    sprite.scale.set(1, 1);
  }

  /**
   * Load textpure packer frames for FlxSprite.
   *
   * @param sprite sprite parent to load frames on
   * @param path where frames are located, exclude extention and assets/images/
   */
  public static function loadFrames(sprite:FlxSprite, path:String) {
    sprite.frames = FlxAtlasFrames.fromTexturePackerJson('assets/images/$path.png', 'assets/images/$path.json');
  }
}
