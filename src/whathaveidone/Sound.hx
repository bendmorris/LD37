package whathaveidone;

import haxepunk.Sfx;


class Sound
{
	static var loaded:Map<String, Sfx> = new Map();
	static var muted:Bool = false;

	public static function play(sound:String)
	{
		if (!loaded.exists(sound))
		{
			loaded[sound] = new Sfx('assets/sounds/$sound.wav');
			loaded[sound].type = "sfx";
		}
		loaded[sound].play();
	}

	public static function toggleMute()
	{
		muted = !muted;
		Sfx.setVolume("sfx", muted ? 0 : 1);
	}
}
