package whathaveidone;

import haxepunk.Sfx;


class Music
{
	static var loaded:Map<String, Sfx> = new Map();
	static var current:Sfx;

	public static function play(music:String)
	{
		if (current != null)
		{
			current.stop();
		}
		if (!loaded.exists(music))
		{
			loaded[music] = new Sfx('assets/music/$music.wav');
		}
		current = loaded[music];
		current.play(1, 0, true);
	}
}
