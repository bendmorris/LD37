package whathaveidone.entities;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Image;


class Meat extends FallingObject
{
	static inline var GLOMPS:Int = 3;

	var remaining:Int = GLOMPS;

	public function new()
	{
		super("meat");
	}
	public function eat():Bool
	{
		var finished = (--remaining) <= 0;
		if (finished)
		{
			scene.remove(this);
		}
		return finished;
	}
}
