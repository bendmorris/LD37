package whathaveidone.graphics;

import spinehaxe.SkeletonData;
import spinehaxe.animation.AnimationStateData;
import spinepunk.SpinePunk;


class SpineBase extends SpinePunk
{
	public static inline var CHAR_SCALE:Float = 0.5;

	static var skeletonDataCache:Map<String, SkeletonData> = new Map();

	public var currentAnimation:String;

	public function new(name:String, ?scale:Float=CHAR_SCALE)
	{
		if (!skeletonDataCache.exists(name))
		{
			skeletonDataCache[name] = SpinePunk.readSkeletonData(name, "assets/graphics/", scale);
		}
		var skeletonData = skeletonDataCache[name];
		var stateData = new AnimationStateData(skeletonData);
		stateData.defaultMix = 0.05;

		super(skeletonData, stateData);
	}

	public function setAnimation(name:AnimationType, ?loop=true)
	{
		if (!loop || currentAnimation != name)
		{
			state.setAnimationByName(0, name, loop);
			currentAnimation = name;
		}
	}
}
