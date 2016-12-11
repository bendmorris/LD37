package whathaveidone.entities;

import spinehaxe.Event;
import spinehaxe.animation.TrackEntry;
import haxepunk.HXP;
import haxepunk.Entity;
import whathaveidone.graphics.Flash;
import whathaveidone.graphics.SpineBase;


class Sword extends Entity
{
	var monster:Monster;
	var spine:SpineBase;
	var flash:Flash;

	public function new(monster:Monster, flash:Flash)
	{
		super();

		this.monster = monster;
		this.flash = flash;

		graphic = spine = new SpineBase("sword", 1);
		spine.state.onEvent.add(onHit);

		x = HXP.width / 2;
		y = HXP.height;
	}

	public function swing()
	{
		spine.setAnimation(AnimationType.Swing, false);
	}

	function onHit(trackEntry:TrackEntry, event:Event)
	{
		if (monster.spine.currentAnimation == AnimationType.Eat)
		{
			Sound.play("sword");
			HXP.screen.shake();
			flash.flash();
			monster.hit();
		}
		else
		{
			Sound.play("deflect");
		}
	}
}
