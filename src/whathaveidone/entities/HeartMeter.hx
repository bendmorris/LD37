package whathaveidone.entities;

import haxepunk.Entity;
import haxepunk.graphics.BitmapText;
import haxepunk.graphics.Image;
import whathaveidone.graphics.Icon;


@:enum
abstract HeartMeterType(String) from String to String
{
	var Hungry = "Hungry";
	var Happy = "Happy";
	var Progress = "Progress";
	var Health = "Health";
}


class HeartMeter extends Entity
{
	var monster:Monster;
	var heartMeterType:HeartMeterType;
	var hearts:Array<Icon> = new Array();

	public function new(monster:Monster, type:HeartMeterType)
	{
		super();

		this.monster = monster;
		this.heartMeterType = type;

		var txt = new BitmapText(
			type,
			{font: 'assets/fonts/a_little_sunshine_regular_48.fnt'}
		);
		txt.x = 16;
		txt.scale = 0.75;
		addGraphic(txt);

		for (i in 0 ... Defs.HEARTS)
		{
			var heart = new Icon(IconType.HeartEmpty);
			heart.x = 128 + i * 64;
			addGraphic(heart);
			hearts.push(heart);
		}

		width = 150 + Defs.HEARTS * 64;
		height = 64;
	}

	override public function update()
	{
		var val:Float = switch (heartMeterType)
		{
			case Hungry: monster.hungry;
			case Happy: monster.happy;
			case Progress: monster.progress;
			case Health: monster.health;
		}

		var filledHearts = val * Defs.HEARTS;
		var fullHearts = Std.int(filledHearts);

		for (i in 0 ... fullHearts)
		{
			hearts[i].iconType = IconType.HeartFull;
		}
		if (fullHearts < Defs.HEARTS)
		{
			var partial = filledHearts % 1;
			hearts[fullHearts].iconType = (partial < 0.25) ? IconType.HeartEmpty :
				((partial > 0.75) ? IconType.HeartFull : IconType.HeartHalf);
		}
		if (fullHearts + 1 < Defs.HEARTS)
		{
			for (i in fullHearts + 1 ... Defs.HEARTS)
			{
				hearts[i].iconType = IconType.HeartEmpty;
			}
		}
	}
}
