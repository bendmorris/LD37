package whathaveidone.entities;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.Sfx;
import haxepunk.graphics.Emitter;
import haxepunk.graphics.Graphiclist;
import whathaveidone.graphics.MonsterSpine;


class Monster extends Entity
{
	static inline var MAX_LEVEL:Int = 5;
	static inline var MOVE_PER_SECOND:Int = 128;

	static function randomPosition(v1:Float, vsize:Float, cur:Float)
	{
		var v:Float;
		do
		{
			v = v1 + vsize * Math.random();
		}
		while (Math.abs(v - cur) < 32);
		return v;
	}

	public var monsterType:MonsterType = MonsterType.Egg;
	public var level:Float = 1;

	public var hungry:Float = 0;
	public var happy:Float = 0;

	public var progress:Float = 0;

	public var timeToEvolve(get, never):Float;
	inline function get_timeToEvolve() return switch (level)
	{
		case 1: 10;
		default: 300;
	}

	public var speed(get, never):Float;
	inline function get_speed() return switch(monsterType)
	{
		case Egg: 0;
		case Bat: 1.5;
		default: 1;
	}

	var emitter:Emitter;
	var spine:MonsterSpine;
	var behavior:MonsterBehavior = null;

	var cracks:Int = 0;

	public function new()
	{
		super();

		graphic = new Graphiclist();

		loadGraphic();

		emitter = new Emitter("assets/graphics/dust.png", 128, 128);
		emitter.newType("dust");
		emitter.setMotion("dust", 0, 0, 2, 360, 32, 1);
		emitter.setAlpha("dust");
		emitter.setGravity("dust", 2, 4);
		cast(graphic, Graphiclist).add(emitter);
	}

	override public function update()
	{
		if (level < MAX_LEVEL)
		{
			progress += HXP.elapsed / timeToEvolve;
			if (progress >= 1)
			{
				++level;
				if (level == MAX_LEVEL)
				{
					// oh no!
				}
				else
				{
					evolve();
				}
				progress -= 1;
			}
		}

		if (level > 1)
		{
			if (behavior == null)
			{
				behavior = getRandomBehavior();
			}
			switch (behavior)
			{
				case Idle(duration):
					spine.setAnimation(AnimationType.Idle);
					if (HXP.elapsed > duration)
					{
						behavior = null;
					}
					else
					{
						behavior = Idle(duration - HXP.elapsed);
					}

				case Move(dx, dy):
					spine.setAnimation(AnimationType.Walk);
					var maxMove = MOVE_PER_SECOND * speed * HXP.elapsed;
					if (Math.abs(x - dx) + Math.abs(y - dy) < maxMove)
					{
						x = dx;
						y = dy;
						behavior = null;
					}
					else
					{
						var vx = Math.abs(x - dx),
							vy = Math.abs(y - dy),
							vlen = vx + vy;
						vx /= vlen;
						vy /= vlen;

						spine.skeleton.flipX = x > dx;

						x += (x > dx ? -1 : 1) * maxMove * vx;
						y += (y > dy ? -1 : 1) * maxMove * vy;
					}
			}
		}
		else
		{
			// crack the egg
			if (progress > 0.75)
			{
				if (cracks < 2)
				{
					Sound.play("crack");
					++cracks;
				}
				spine.skeleton.setAttachment("egg", "egg_very_cracked");
			}
			else if (progress >= 0.5)
			{
				if (cracks < 1)
				{
					Sound.play("crack");
					++cracks;
				}
				spine.skeleton.setAttachment("egg", "egg_cracked");
			}
		}
	}

	function loadGraphic()
	{
		spine = new MonsterSpine(monsterType);
		var gl:Graphiclist = cast graphic;
		if (gl.children.length == 0)
		{
			gl.add(spine);
		}
		else
		{
			gl.children[0] = spine;
		}
		spine.setAnimation(AnimationType.Idle);
	}

	function evolve():Void
	{
		Sound.play("evolve");
		for (i in 0 ... 32)
		{
			emitter.emitInCircle("dust", 0, -64, 128);
		}

		switch (monsterType)
		{
			case MonsterType.Egg:
				monsterType = MonsterType.Blob;
				Music.play("main");
			case MonsterType.Blob:
				var choices = [MonsterType.Slime, MonsterType.Mammal, MonsterType.Bat];
				monsterType = choices[Std.random(choices.length)];
			case MonsterType.Slime:
				monsterType = MonsterType.BigSlime;
			case MonsterType.Mammal:
				monsterType = MonsterType.BigMammal;
			case MonsterType.Bat:
				monsterType = MonsterType.BigBat;
			default: {}
		}

		loadGraphic();
		behavior = Idle(5);
	}

	function getRandomBehavior():MonsterBehavior
	{
		return (Math.random() < 0.5)
			? MonsterBehavior.Idle(1 + Math.random() * 4)
			: MonsterBehavior.Move(
				randomPosition(Client.monsterBounds.x, Client.monsterBounds.width, x),
				randomPosition(Client.monsterBounds.y, Client.monsterBounds.height, y)
			)
		;
	}
}
