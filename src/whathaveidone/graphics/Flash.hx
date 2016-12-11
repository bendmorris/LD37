package whathaveidone.graphics;

import flash.display.BitmapData;
import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Backdrop;


class Flash extends Entity
{
	static inline var FLASH_TIME:Float = 0.5;

	var backdrop:Backdrop;

	public function new()
	{
		super();

		var bmd = new BitmapData(16, 16, false, 0xffff0000);
		graphic = backdrop = new Backdrop(bmd);

		backdrop.alpha = 0;
		layer = 0;
	}

	override public function update()
	{
		if (backdrop.alpha > 0)
		{
			backdrop.alpha -= HXP.elapsed / FLASH_TIME;
			if (backdrop.alpha < 0) backdrop.alpha = 0;
		}
	}

	public function flash()
	{
		backdrop.alpha = 1;
	}
}
