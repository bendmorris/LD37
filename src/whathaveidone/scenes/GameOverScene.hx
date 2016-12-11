package whathaveidone.scenes;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.Scene;
import haxepunk.graphics.BitmapText;
import haxepunk.graphics.Image;
import haxepunk.utils.Input;


class GameOverScene extends Scene
{
	public function new()
	{
		super();

		var txt = new BitmapText(
			"I hoped it would end differently this time...",
			{font: 'assets/fonts/a_little_sunshine_regular_48.fnt'}
		);
		txt.x = 16;
		txt.y = 16;
		addGraphic(txt);

		var img = new Image("assets/graphics/gameover.png");
		img.x = (HXP.width - img.width) / 2;
		img.y = (HXP.height - img.height) / 2;
		addGraphic(img);

		transparent = true;
	}

	override public function update()
	{
		if (Input.mousePressed)
		{
			HXP.engine.popScene();
			HXP.engine.popScene();
			HXP.engine.pushScene(new GameScene());
		}
	}
}
