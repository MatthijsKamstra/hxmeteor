package meteor.packages.files;

/**
 *
 * https://github.com/VeliovGroup/Meteor-Files/wiki/FilesCursor
 *
 * FilesCursor
 * @author Matthijs Kamstra aka [mck]
 */
extern class FilesCursor{

	// @:overload(function(cb:(Dynamic)->Void, ?thisArg:Dynamic):Void{})
	// @:overload(function(cb:(Dynamic->Int)->Void, ?thisArg:Dynamic):Void{})
	// function forEach(cb:(Dynamic->Int->Cursor)->Void, ?thisArg:Dynamic):Void;

	// @:overload(function(cb:(Dynamic)->Void, ?thisArg:Dynamic):Array<Dynamic>{})
	// @:overload(function(cb:(Dynamic->Int)->Void, ?thisArg:Dynamic):Array<Dynamic>{})
	// function map(cb:(Dynamic->Int->Cursor)->Void, ?thisArg:Dynamic):Array<Dynamic>;

	// function fetch():Array<Dynamic>;
	// function count():Int;
	// function observe(callbacks: { } ):Void;
	// function observeChanges(callbacks: { } ):Void;

	var cursor : Cursor;


	function get():Array<Dynamic>; // - {[Object]} - Returns all matching document(s) as an Array. Alias of .fetch()
	function hasNext() : Bool; //- {Boolean} - Returns true if there is next item available on Cursor
	function next() : Dynamic; // - {Object|undefined} - Returns next available object on Cursor
	function hasPrevious() : Bool; // - {Boolean} - Returns true if there is previous item available on Cursor
	function previous() : Dynamic; // - {Object|undefined} - Returns previous object on Cursor
	function fetch() : Array<Dynamic>; // - {[Object]} - Returns all matching document(s) as an Array
	function first() : Dynamic; // - {Object|undefined} - Returns first item on Cursor, if available
	function last() : Dynamic; // - {Object|undefined} - Returns last item on Cursor, if available
	function count() : Int; // - {Number} - Returns the number of documents that match a query
	// function remove(callback) - {undefined} - Removes all documents that match a query. Callback has error argument
	// function forEach(callback, context) - {undefined} - Call callback once for each matching document, sequentially and synchronously.
	function each() : Array<FileCursor>; // - {[FileCursor]} - Returns an Array of FileCursor made for each document on current Cursor. Useful when using in {{#each FilesCursor#each}}...{{/each}} block template helper
	// function map(callback, context) - {Array} - Map callback over all matching documents. Returns an Array
	function current() : Dynamic; //- {Object|undefined} - Returns current item on Cursor, if available
	function observe(callbacks : {}):Void;//  - {Object} - Functions to call to deliver the result set as it changes. Watch a query. Receive callbacks as the result set changes. Read more here
	function observeChanges(callbacks : {}):Void; // - {Object} - Watch a query. Receive callbacks as the result set changes. Only the differences between the old and new documents are passed to the callbacks.. Read more here

}