package whathaveidone.scenes;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.Scene;
import haxepunk.graphics.BitmapText;
import haxepunk.utils.Input;


class TitleScene extends Scene
{
	public function new()
	{
		super();

		var txt = new BitmapText(
			"WHAT HAVE I DONE?\n\nA virtual pet game\n\nCreated by bendmorris for Ludum Dare 37\n\nClick to begin",
			{font: 'assets/fonts/a_little_sunshine_regular_48.fnt'}
		);
		addGraphic(txt);

		transparent = true;
	}

	override public function begin()
	{

	}

	override public function update()
	{
		if (Input.mousePressed)
		{
			HXP.engine.popScene();
		}
	}
}
