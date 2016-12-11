package whathaveidone;

import whathaveidone.entities.Meat;
import whathaveidone.graphics.Icon.IconType;


enum MonsterBehavior
{
	Idle(duration:Float);
	Move(x:Float, y:Float);
	Want(iconType:IconType, duration:Float);
	Eat(meat:Meat);
	Poo;
}
