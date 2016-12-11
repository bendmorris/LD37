package whathaveidone.entities;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Image;


class Meat extends Entity
{
	static inline var FALL_TIME:Float = 1.5;
	static inline var GLOMPS:Int = 3;

	var remaining:Int = GLOMPS;
	var shadow:Image;
	var meat:Image;

	public function new()
	{
		super();

		type = "meat";

		shadow = new Image("assets/graphics/shadow.png");
		shadow.originX = shadow.width / 2;
		shadow.originY = shadow.height * 0.75;
		addGraphic(shadow);

		meat = new Image("assets/graphics/meat.png");
		meat.y = -HXP.height;
		meat.originX = meat.width / 2;
		meat.originY = meat.height * 0.75;
		addGraphic(meat);

		width = meat.width;
		height = meat.height;
	}

	override public function update()
	{
		if (meat.y < 0)
		{
			shadow.scale = HXP.clamp(1 - (-meat.y / HXP.height), 0, 1);
			meat.y += HXP.height * HXP.elapsed / FALL_TIME;
			if (meat.y >= 0)
			{
				meat.y = 0;
				shadow.visible = false;
			}
		}

		layer = Std.int(HXP.height * 2 - (y + 4));
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
