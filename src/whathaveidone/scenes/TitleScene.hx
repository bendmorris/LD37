package whathaveidone.scenes;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.Scene;
import haxepunk.graphics.BitmapText;
import haxepunk.utils.Input;


class TitleScene extends Scene
{
	static inline var FADE_TIME:Float = 0.75;

	var fade:Bool = false;
	var txt:BitmapText;

	public function new()
	{
		super();

		txt = new BitmapText(
			"WHAT HAVE I DONE?\n\nA virtual pet simulator\n\nCreated by bendmorris for Ludum Dare 37\n\nClick to begin",
			{font: 'assets/fonts/a_little_sunshine_regular_48.fnt'}
		);
		txt.x = 16;
		txt.y = 16;
		addGraphic(txt);

		color = 0;
		alpha = 1;
	}

	override public function update()
	{
		if (fade)
		{
			txt.alpha = (alpha -= HXP.elapsed / FADE_TIME);
			if (alpha <= 0)
			{
				HXP.engine.popScene();
			}
		}
		else if (Input.mousePressed)
		{
			fade = true;
		}
	}
}
