package whathaveidone.entities;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Image;
import whathaveidone.MonsterBehavior;


class Ball extends FallingObject
{
	static inline var DISTANCE_PER_SECOND:Float = 800;

	public var kickTime:Float = 0;
	var dx:Float = 0;
	var dy:Float = 0;

	public function new()
	{
		super("ball");
	}

	override public function update()
	{
		super.update();

		if (obj.y == 0)
		{
			if (kickTime > 0)
			{
				x += dx * DISTANCE_PER_SECOND * HXP.elapsed;
				y += dy * DISTANCE_PER_SECOND * HXP.elapsed;
				kickTime -= HXP.elapsed;
				if (kickTime <= 0)
				{
					scene.remove(this);
				}
			}
			else
			{
				var monster:Monster = cast collide("monster", x, y);
				if (monster != null && monster.behavior != null)
				{
					switch (monster.behavior)
					{
						case Move(x, y):
							// kick the ball
							kickTime = 1;
							dx = (this.x - monster.x) * 2;
							dy = this.y - monster.y;
							var dl = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
							dx /= dl;
							dy /= dl;

							Sound.play("hit");
							HXP.screen.shake();
							monster.makeHappy();

						default:
					}
				}
			}
		}
	}
}
