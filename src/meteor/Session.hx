package meteor;

/**
 * Session provides a global object on the client that you can use to store an arbitrary set of key-value pairs. Use it to store things like the currently selected item in a list.
 *
 * @author TiagoLr
 */
@:native('Session')
extern class Session{
	static function setDefault(key:String, value:Dynamic):Void;
	static function set(key:String, value:Dynamic):Void;
	static function get(key:String):Dynamic;
	static function equals(key:String, value:Dynamic):Bool;
}