package whathaveidone.entities;

import spinehaxe.Event;
import spinehaxe.animation.TrackEntry;
import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.Sfx;
import haxepunk.graphics.Emitter;
import haxepunk.graphics.Graphiclist;
import whathaveidone.graphics.Bubble;
import whathaveidone.graphics.Icon;
import whathaveidone.graphics.MonsterSpine;


class Monster extends Entity
{
	public static inline var MAX_LEVEL:Int = 4;

	static inline var MOVE_PER_SECOND:Int = 128;
	static inline var HUNGRY_HEART_SECONDS:Float = 60;
	static inline var HAPPY_HEART_SECONDS:Float = 5;

	static inline var MEAT_TO_POO:Float = 3;
	static inline var SICK_CHANCE:Float = 0.02;
	static inline var POO_SICK_CHANCE:Float = 0.75;

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
	public var level:Int = 1;

	public var health:Float = 1;
	public var sick:Bool = false;
	public var hungry:Float = 0;
	public var happy:Float = 0;
	public var progress:Float = 0;

	public var spine:MonsterSpine;

	public var timeToEvolve(get, never):Float;
	inline function get_timeToEvolve() return switch (level)
	{
		case 1: 15;
		default: 120;
	}

	public var speed(get, never):Float;
	inline function get_speed() return switch(monsterType)
	{
		case Egg: 0;
		case Bat: 1.5;
		default: 1;
	}

	var emitter:Emitter;
	var bubble:Bubble;
	var behavior:MonsterBehavior = null;

	var cracks:Int = 0;
	var pooProgress:Float = 0;
	var avgHappiness:Float = 0;

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
				evolve();
				progress -= 1;

				if (level == MAX_LEVEL)
				{
					Music.play("creepy");
				}
			}
		}
		else
		{
			happy = 0;
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
					if (walkTowards(dx, dy))
					{
						behavior = null;
					}

				case Eat(meat):
					if (walkTowards(meat.x, meat.y))
					{
						spine.setAnimation(AnimationType.Eat);
					}
					else
					{
						spine.setAnimation(AnimationType.Walk);
					}

				case Poo:
					var poo = new Poo();
					poo.x = x;
					poo.y = y;
					scene.add(poo);
					Sound.play("glomp");
					behavior = null;

				case Want(iconType, duration):
					spine.setAnimation(AnimationType.Sad);

					if (iconType == IconType.Shot && !sick)
					{
						duration = 0;
					}

					if (bubble == null)
					{
						bubble = new Bubble(iconType);
						bubble.x = -32;
						bubble.y = -32;
						addGraphic(bubble);
					}
					if (HXP.elapsed > duration)
					{
						var gl:Graphiclist = cast graphic;
						gl.remove(bubble);
						bubble = null;
						behavior = Idle(2);
					}
					else
					{
						behavior = Want(iconType, duration - HXP.elapsed);
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

		hungry -= (1 / Defs.HEARTS * HXP.elapsed / HUNGRY_HEART_SECONDS);
		hungry = HXP.clamp(hungry, 0, 1);

		var satisfied:Bool = true;
		if (sick || Defs.hearts(hungry) < Defs.MIN_HEARTS)
		{
			satisfied = false;
		}
		if (satisfied)
		{
			var poo = findPoo();
			if (poo != null)
			{
				satisfied = false;
			}
		}

		if (level < MAX_LEVEL)
		{
			happy += (satisfied ? 1 : -0.5) * (1 / Defs.HEARTS * HXP.elapsed / HAPPY_HEART_SECONDS);
			happy = HXP.clamp(happy, 0, 1);

			avgHappiness += happy * (HXP.elapsed / timeToEvolve);
		}

		layer = Std.int(HXP.height * 2 - y);
	}

	public function hit()
	{
		health -= 1 / Defs.HEARTS;
		if (health <= 0.0001) health = 0;
	}

	public function randomX() return randomPosition(Client.monsterBounds.x, Client.monsterBounds.width, x);
	public function randomY() return randomPosition(Client.monsterBounds.y, Client.monsterBounds.height, y);

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
		spine.state.onComplete.add(animationCompleteHandler);
		spine.state.onEvent.add(animationEventHandler);
	}

	function walkTowards(dx:Float, dy:Float):Bool
	{
		var maxMove = MOVE_PER_SECOND * speed * HXP.elapsed;
		if (Math.abs(x - dx) + Math.abs(y - dy) < maxMove)
		{
			x = dx;
			y = dy;
			return true;
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
			return false;
		}
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
				monsterType = choices[Std.int(Math.round(avgHappiness * choices.length))];
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
		avgHappiness = 0;
	}

	function getRandomBehavior():MonsterBehavior
	{
		if (sick)
		{
			return Want(IconType.Shot, 4);
		}

		if (pooProgress >= MEAT_TO_POO)
		{
			pooProgress -= MEAT_TO_POO;
			return Poo;
		}

		if (Defs.hearts(hungry) < Defs.HEARTS)
		{
			var meat = findMeat();
			if (meat != null)
			{
				return Eat(meat);
			}
			else if (hungry < 0.4)
			{
				return Want(IconType.Fork, 4);
			}
		}

		return (Math.random() < 0.5)
			? Idle(1 + Math.random() * 4)
			: Move(
				randomX(),
				randomY()
			)
		;
	}

	function findMeat():Null<Meat>
	{
		return cast scene.collideRect("meat", 0, 0, HXP.width, HXP.height);
	}

	function findPoo():Null<Poo>
	{
		return cast scene.collideRect("poo", 0, 0, HXP.width, HXP.height);
	}

	function animationCompleteHandler(trackEntry:TrackEntry):Void
	{
		if (behavior != null)
		{
			switch (behavior)
			{
				case Eat(meat):
					if (spine.currentAnimation == AnimationType.Eat && meat.eat())
					{
						hungry += 1 / Defs.HEARTS;
						if (hungry > 1) hungry = 1;
						behavior = null;
						++pooProgress;

						if (level < MAX_LEVEL)
						{
							var sickChance = (findPoo() == null) ? SICK_CHANCE : POO_SICK_CHANCE;
							if (Math.random() < sickChance)
							{
								sick = true;
							}
						}
					}

				default:
			}
		}
	}

	function animationEventHandler(trackEntry:TrackEntry, event:Event):Void
	{
		switch (event.data.name)
		{
			case "sound":
				Sound.play(event.stringValue);

			default:
		}
	}
}
