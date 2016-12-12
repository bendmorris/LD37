package whathaveidone.scenes;

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.Scene;
import haxepunk.graphics.BitmapText;
import haxepunk.graphics.Image;
import haxepunk.utils.Input;


class GameOverScene extends Scene
{
	static inline var FADE_TIME:Float = 5;

	var clickBuffer:Float = 1;

	var img:Image;
	var txt:BitmapText;

	public function new()
	{
		super();

		txt = new BitmapText(
			"I hoped it would end differently this time...",
			{font: 'assets/fonts/a_little_sunshine_regular_48.fnt'}
		);
		txt.x = 16;
		txt.y = 16;
		txt.alpha = 0;
		addGraphic(txt);

		img = new Image("assets/graphics/gameover.png");
		img.x = (HXP.width - img.width) / 2;
		img.y = (HXP.height - img.height) / 2;
		img.alpha = 0;
		addGraphic(img);
	}

	override public function update()
	{
		if (clickBuffer > 0)
		{
			clickBuffer -= HXP.elapsed / FADE_TIME;
			if (clickBuffer < 0) clickBuffer = 0;
			txt.alpha = img.alpha = 1 - clickBuffer;
		}
		else if (Input.mousePressed)
		{
			HXP.engine.popScene();
			HXP.engine.popScene();
			HXP.engine.pushScene(new GameScene());
		}
	}
}
