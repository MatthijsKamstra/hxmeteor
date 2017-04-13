package meteor.packages.files;

/**
 *
 * https://github.com/VeliovGroup/Meteor-Files
 * https://github.com/VeliovGroup/Meteor-Files/wiki
 *
 * FileCursor
 * @author Matthijs Kamstra aka [mck]
 */
extern class FileCursor{

	function remove(callbacks: { }):Void; // - {undefined} - Remove document. Callback has error argument
	function link() : String; // - {String} - Returns downloadable URL to File
	function get(property:String) : Dynamic; // - {Object|mix} - Returns current document as a plain Object, if property is specified - returns value of sub-object property
	function fetch():Array<Dynamic>; // - {[Object]}- Returns current document as plain Object in Array
	function with():FileCursor; // - {FileCursor} - Returns reactive version of current FileCursor, useful to use with {{#with FileCursor#with}}...{{/with}} block template helper


}