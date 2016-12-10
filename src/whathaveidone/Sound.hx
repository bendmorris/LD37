package whathaveidone;

import haxepunk.Sfx;


class Sound
{
	static var loaded:Map<String, Sfx> = new Map();

	public static function play(sound:String)
	{
		if (!loaded.exists(sound))
		{
			loaded[sound] = new Sfx('assets/sounds/$sound.wav');
		}
		loaded[sound].play();
	}
}
