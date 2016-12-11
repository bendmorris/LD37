package whathaveidone.entities;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Image;
import haxepunk.graphics.Emitter;


class Poo extends Entity
{
	static inline var FLUSH_TIME:Float = 1.5;

	var eliminateTimer:Float = 0;

	var poo:Image;
	var emitter:Emitter;

	public function new()
	{
		super();

		type = "poo";

		poo = new Image("assets/graphics/poo.png");
		poo.originX = poo.width / 2;
		poo.originY = poo.height * 0.75;
		addGraphic(poo);

		emitter = new Emitter("assets/graphics/steam.png", 64, 64);
		emitter.newType("steam");
		emitter.setMotion("steam", 90, 16, 1, 0, 32, 1);
		emitter.setAlpha("steam");
		emitter.setGravity("steam", 1, 1);
		addGraphic(emitter);

		width = poo.width;
		height = poo.height;
	}

	public function eliminate()
	{
		if (eliminateTimer == 0)
		{
			eliminateTimer = 1;
		}
	}

	override public function update()
	{
		if (Math.random() < 0.02)
		{
			emitter.emitInCircle("steam", 0, -32, 32);
		}
		if (eliminateTimer > 0)
		{
			eliminateTimer -= HXP.elapsed / (FLUSH_TIME / 2);
			poo.alpha = eliminateTimer / (FLUSH_TIME / 2);
			if (eliminateTimer <= 0)
			{
				scene.remove(this);
			}
		}

		layer = Std.int(HXP.height * 2 - (y + 4));
	}
}
