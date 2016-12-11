package whathaveidone.scenes;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.Scene;
import haxepunk.graphics.Backdrop;
import whathaveidone.entities.Button;
import whathaveidone.entities.HeartMeter;
import whathaveidone.entities.Meat;
import whathaveidone.entities.Monster;
import whathaveidone.entities.Poo;
import whathaveidone.entities.Sword;
import whathaveidone.graphics.Flash;
import whathaveidone.graphics.Icon;


class GameScene extends Scene
{
	var _started:Bool = false;

	var monster:Monster;

	var hungryMeter:HeartMeter;
	var happyMeter:HeartMeter;
	var progressMeter:HeartMeter;
	var healthMeter:HeartMeter;
	var foodButton:Button;
	var duckButton:Button;
	var shotButton:Button;

	var switchedButtons:Bool = false;
	var sword:Sword;
	var flash:Flash;

	public function new()
	{
		super();

		var egg = new whathaveidone.graphics.SpineBase("egg");
		egg.setAnimation("idle");
		addGraphic(new Backdrop("assets/graphics/bg.png")).layer = HXP.height * 2;
		add(monster = new Monster());
		monster.x = HXP.width*0.5;
		monster.y = HXP.height*0.75;

		// hearts
		hungryMeter = new HeartMeter(monster, HeartMeterType.Hungry);
		hungryMeter.x = 8;
		hungryMeter.y = 8;
		happyMeter = new HeartMeter(monster, HeartMeterType.Happy);
		happyMeter.x = hungryMeter.x;
		happyMeter.y = hungryMeter.y + hungryMeter.height;
		progressMeter = new HeartMeter(monster, HeartMeterType.Progress);
		progressMeter.x = hungryMeter.x;
		progressMeter.y = HXP.height - hungryMeter.y - progressMeter.height;
		add(hungryMeter);
		add(happyMeter);
		add(progressMeter);

		// buttons
		foodButton = new Button(IconType.Fork, pressFeed);
		foodButton.y = 8;
		foodButton.x = HXP.width - 8 - foodButton.width;
		add(foodButton);
		duckButton = new Button(IconType.Duck, pressDuck);
		duckButton.y = foodButton.y + foodButton.height + 8;
		duckButton.x = foodButton.x;
		add(duckButton);
		shotButton = new Button(IconType.Shot, pressShot);
		shotButton.y = duckButton.y + duckButton.height + 8;
		shotButton.x = foodButton.x;
		add(shotButton);

		var muteButton = new Button(IconType.Mute, pressMute);
		muteButton.y = HXP.height - foodButton.y - muteButton.height;
		muteButton.x = foodButton.x;
		add(muteButton);
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

	override public function update()
	{
		super.update();

		if (!switchedButtons && monster.level == Monster.MAX_LEVEL)
		{
			remove(shotButton);
			var swordButton = new Button(IconType.Sword, pressSword);
			swordButton.y = shotButton.y;
			swordButton.x = shotButton.x;
			add(swordButton);
			switchedButtons = true;

			remove(happyMeter);
			remove(progressMeter);
			healthMeter = new HeartMeter(monster, HeartMeterType.Health);
			healthMeter.x = happyMeter.x;
			healthMeter.y = happyMeter.y;
			add(healthMeter);
		}

		if (monster.health <= 0)
		{
			HXP.engine.pushScene(new GameOverScene());
		}
	}

	function pressFeed()
	{
		var meat:Meat = cast collideRect("meat", 0, 0, HXP.width, HXP.height);
		if (meat == null)
		{
			Sound.play("give");
			meat = new Meat();
			meat.x = monster.randomX();
			meat.y = monster.randomY();
			add(meat);
		}
	}

	function pressDuck()
	{
		HXP.screen.shake(1.5);
		Sound.play("flush");
		var poo:Poo = cast collideRect("poo", 0, 0, HXP.width, HXP.height);
		if (poo == null)
		{
			monster.happy -= 0.5 / Defs.HEARTS;
			if (monster.happy < 0) monster.happy = 0;
		}
		else
		{
			poo.eliminate();
		}
	}

	function pressShot()
	{
		HXP.screen.shake();
		monster.happy -= 0.5 / Defs.HEARTS;
		if (monster.sick)
		{
			if (Math.random() < 0.75) monster.sick = false;
		}
	}

	function pressSword()
	{
		if (flash == null)
		{
			flash = new Flash();
			add(flash);
		}
		if (sword == null)
		{
			sword = new Sword(monster, flash);
			add(sword);
		}
		else
		{
			sword.swing();
		}
	}

	function pressMute()
	{
		Sound.toggleMute();
		Music.toggleMute();
	}
}
