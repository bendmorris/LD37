import openfl.Assets;
import openfl.display.Sprite;
import haxepunk.HXP;
import haxepunk.Engine;
import haxepunk.graphics.Image;
import whathaveidone.Client;

class Main extends Engine
{
	public function new()
	{
		super(Client.WIDTH, Client.HEIGHT, 60, false);
	}

	override public function init()
	{
		#if debug
		HXP.console.enable();
		#end

		HXP.stage.quality = flash.display.StageQuality.BEST;
		pushScene(new whathaveidone.scenes.GameScene());
	}
}
