package whathaveidone.graphics;

import haxepunk.graphics.Graphiclist;
import haxepunk.graphics.Image;
import whathaveidone.graphics.Icon;


class Bubble extends Graphiclist
{
	public function new(iconType:IconType)
	{
		super();

		var bubble = new Image("assets/graphics/bubble.png");
		bubble.originX = bubble.width;
		bubble.originY = bubble.height;
		add(bubble);

		var icon = new Icon(iconType);
		icon.x = 32 - bubble.width;
		icon.y = 16 - bubble.height;
		add(icon);
	}
}
