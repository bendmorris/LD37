package whathaveidone.graphics;

import haxepunk.graphics.Spritemap;


@:enum
abstract IconType(Int) from Int to Int
{
	var HeartEmpty = 0;
	var HeartHalf = 1;
	var HeartFull = 2;

	var Button = 3;

	var Fork = 4;
	var Duck = 5;
	var Shot = 6;
	var Sword = 7;
	var Ball = 8;

	var Mute = 9;
}


class Icon extends Spritemap
{
	public var iconType(default, set):IconType;
	inline function set_iconType(type:IconType)
	{
		frame = type;
		return iconType = type;
	}

	public function new(type:IconType)
	{
		super("assets/graphics/icons.png", 64, 64);
		iconType = type;
	}
}
