package whathaveidone;

import haxepunk.Sfx;


class Music
{
	static var loaded:Map<String, Sfx> = new Map();
	static var current:Sfx;
	static var muted:Bool = false;

	public static function play(music:String)
	{
		if (current != null)
		{
			current.stop();
		}
		if (!loaded.exists(music))
		{
			loaded[music] = new Sfx('assets/music/$music.ogg');
			loaded[music].type = "music";
		}
		current = loaded[music];
		current.play(1, 0, true);
	}


	public static function toggleMute()
	{
		muted = !muted;
		Sfx.setVolume("music", muted ? 0 : 1);
	}
}
