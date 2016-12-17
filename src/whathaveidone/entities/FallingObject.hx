package whathaveidone.entities;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Image;


class FallingObject extends Entity
{
	static inline var FALL_TIME:Float = 1.5;

	var shadow:Image;
	var obj:Image;

	public function new(type:String)
	{
		super();

		this.type = type;

		shadow = new Image("assets/graphics/shadow.png");
		shadow.originX = shadow.width / 2;
		shadow.originY = shadow.height * 0.75;
		addGraphic(shadow);

		obj = new Image('assets/graphics/$type.png');
		obj.y = -HXP.height;
		obj.originX = obj.width / 2;
		obj.originY = obj.height * 0.75;
		addGraphic(obj);

		width = obj.width;
		height = obj.height;
		originX = Std.int(obj.width / 2);
		originY = Std.int(obj.height * 0.75);
	}

	override public function update()
	{
		if (obj.y < 0)
		{
			shadow.scale = HXP.clamp(1 - (-obj.y / HXP.height), 0, 1);
			obj.y += HXP.height * HXP.elapsed / FALL_TIME;
			if (obj.y >= 0)
			{
				obj.y = 0;
				shadow.visible = false;
			}
		}

		layer = Std.int(HXP.height * 2 - (y + 4));
	}
}
