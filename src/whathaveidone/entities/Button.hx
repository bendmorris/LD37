package whathaveidone.entities;

import haxepunk.Entity;
import haxepunk.utils.Input;
import whathaveidone.graphics.Icon;


class Button extends Entity
{
	static inline var ACTIVE_COLOR:Int = 0xffffff;
	static inline var INACTIVE_COLOR:Int = 0xc0c0c0;

	var onClick:Void->Void;

	var btn:Icon;
	var icon:Icon;

	public function new(iconType:IconType, ?onClick:Void->Void)
	{
		super();

		type = "button";

		btn = new Icon(IconType.Button);
		addGraphic(btn);
		icon = new Icon(iconType);
		addGraphic(icon);

		this.onClick = onClick;

		width = btn.width;
		height = btn.height;
	}

	override public function update()
	{
		var over = (scene.collidePoint(type, scene.mouseX, scene.mouseY) == this);
		btn.color = icon.color = over ? ACTIVE_COLOR : INACTIVE_COLOR;
		if (over && Input.mousePressed && onClick != null)
		{
			onClick();
		}
	}
}
