package whathaveidone.graphics;

import spinehaxe.SkeletonData;
import spinehaxe.animation.AnimationStateData;
import spinepunk.SpinePunk;


class SpineBase extends SpinePunk
{
	public static inline var CHAR_SCALE:Float = 0.5;

	static var skeletonDataCache:Map<String, SkeletonData> = new Map();

	var _animation:String;

	public function new(name:String)
	{
		if (!skeletonDataCache.exists(name))
		{
			skeletonDataCache[name] = SpinePunk.readSkeletonData(name, "assets/graphics/", CHAR_SCALE);
		}
		var skeletonData = skeletonDataCache[name];
		var stateData = new AnimationStateData(skeletonData);
		stateData.defaultMix = 0.2;

		super(skeletonData, stateData);
	}

	public function setAnimation(name:AnimationType, ?loop=true)
	{
		if (_animation != name)
		{
			state.setAnimationByName(0, name, loop);
			_animation = name;
		}
	}
}
