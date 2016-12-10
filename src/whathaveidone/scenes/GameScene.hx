package whathaveidone.scenes;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.Scene;
import haxepunk.graphics.Backdrop;
import haxepunk.ui.layout.LayoutGroup;
import whathaveidone.entities.Monster;
//import whathaveidone.entities.HeartMeter;


class GameScene extends Scene
{
	var _started:Bool = false;

	var monster:Monster;

	/*var hungryMeter:HeartMeter;
	var happyMeter:HappyMeter;*/

	public function new()
	{
		super();

		var egg = new whathaveidone.graphics.SpineBase("egg");
		egg.setAnimation("idle");
		addGraphic(new Backdrop("assets/graphics/bg.png"));
		add(monster = new Monster());
		monster.x = HXP.width*0.5;
		monster.y = HXP.height*0.75;

		/*var meterLayout = new LayoutGroup(LayoutType.Vertical);
		hungryMeter = new HeartMeter(monster, HeartMeterType.Hungry);
		happyMeter = new HeartMeter(monster, HeartMeterType.Happy);
		meterLayout.add(hungryMeter);
		meterLayout.add(happyMeter);
		add(meterLayout);*/
	}

	override public function begin()
	{
		if (!_started)
		{
			_started = true;
			HXP.engine.pushScene(new whathaveidone.scenes.TitleScene());
		}
		else
		{
			Music.play("egg");
		}
	}
}
