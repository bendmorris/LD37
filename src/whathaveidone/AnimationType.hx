package whathaveidone;


@:enum
abstract AnimationType(String) from String to String
{
	var Idle = "idle";
	var Walk = "walk";
	var Eat = "eat";
}
