package whathaveidone;


class Defs
{
	public static inline var HEARTS:Int = 4;
	public static inline var MIN_HEARTS:Float = 2.5;

	public static inline function hearts(percent:Float):Float
	{
		var full:Float = Std.int(percent * HEARTS);
		var remaining = (percent * HEARTS) % 1;
		full += (remaining < 0.25) ? 1 : (remaining > 0.75 ? 1 : 0.5);
		return full;
	}
}
