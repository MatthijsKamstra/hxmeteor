package meteor.packages.files;

import meteor.Collection;
import haxe.Constraints.Function;
import haxe.extern.EitherType;
import js.html.File;

typedef FindOneOptions = {
	?sort:Dynamic,
	?skip:Int,
	?fields:Dynamic<Int>,
}

typedef FindOptions = {
	?sort:Dynamic,
	?skip:Int,
	?limit:Int,
	?fields:Dynamic<Int>,
}

typedef UpdateOptions = {
	?multi:Bool,
	?upsert:Bool,

	// requires collections2 package
	?validationContext:String,
	?validate:Bool,
	?getAutoValues:Bool,
	?removeEmptyStrings:Bool,
	?autoConvert:Bool,
	?filter:Bool,
}

typedef InsertOptions = {
	// requires collections2 package
	?validationContext:String,
	?validate:Bool,
	?getAutoValues:Bool,
	?removeEmptyStrings:Bool,
	?autoConvert:Bool,
	?filter:Bool,
}

typedef AllowOptions = {
	@:optional function insert(userid:String, doc:Dynamic):Bool; // userid->document
	@:optional function update(userid:String, doc:Dynamic, fields:Array<String>, modifier:Dynamic):Bool;
	@:optional function remove(userid:String, doc:Dynamic):Bool;
	@:optional var fetch:Array<String>;
}

typedef CollectionOptions = {
	?connection: { },
	?idGeneration:String, // 'STRING' or 'MONGO'
}

typedef CollectionHooks = {
	/** userId -> document */
	function insert(f:Dynamic) : Void;
	/** userId -> document -> fields -> modifier -> options */
	function update(f:Dynamic, ? fetch: { fetchPrevious:Bool } ) : Void;
	/** userId -> document */
	function remove(f:Dynamic) : Void;
	/** userId, selector, modifier, option */
	function upsert(f:Dynamic) : Void;
	/** userId, selector, options, cursor(after only) */
	function find(f:Dynamic) : Void;
	/** userId, selector, options, doc(after only) */
	function findOne(f:Dynamic) : Void;
}



// https://github.com/VeliovGroup/Meteor-Files/wiki/Insert-(Upload)


typedef SettingsObj =
{
	var file : EitherType<String, EitherType<File, Dynamic>>; // {File} or {Object} or {String}	[REQUIRED] HTML5 files item	Ex.: From event: event.currentTarget.files[0] Set to dataURI {String} for Base64
	var streams : EitherType <String, Float>; // {Number|dynamic}	Quantity of parallel upload streams	dynamic is recommended
	var chunkSize : EitherType <String, Float>; // {Number|dynamic}	Chunk size for upload	dynamic is recommended

	@:optional var isBase64 : Bool; // {Boolean}	Upload as base64 string, useful for data taken from canvas	See Examples
	@:optional var meta : Dynamic ; // {Object}	Additional file-related data	Ex.: ownerId, postId, etc.
	@:optional var transport : String; //{String}	Must be set to http or ddp	Note: upload via http is at least twice faster. HTTP will properly work only with "sticky sessions" Default: ddp
	@:optional var ddp : Dynamic; // {Object}	Custom DDP connection for upload. Object returned form DDP.connect()	By default Meteor (The default DDP connection)
	@:optional var allowWebWorkers : Bool; // {Boolean}	Use WebWorkers (To avoid main thread blocking) whenever feature is available in browser	Default: true */
	// var onStart {Function}	Callback, triggered when upload is started and validations was successfulArguments:error - Always nullfileData {Object}
	// var onUploaded {Function}	Callback, triggered when upload is finished Arguments:errorfileRef {Object} - File record from DB
	// var onAbort {Function}	Callback, triggered when abort() method is called Arguments:fileData {Object}
	// var onError {Function}	Callback, triggered when upload finished with error Arguments: error fileData {Object}
	// var onProgress {Function}	Callback, triggered after chunk is sent Arguments: progress {Number} - Current progress from 0 to 100 fileData {Object}
	// var onBeforeUpload {Function}	Callback, triggered right before upload is started Arguments: fileData {Object} Use to check file-type, extension, size, etc. return true to continue return false to abort or {String} to abort upload with message
}


// @:native('$')

// https://github.com/VeliovGroup/Meteor-Files/wiki/Constructor
typedef Config = {
	@:optional var storagePath : EitherType<String, Function>;//  {String|Function}	Server	Storage path on file system	function { return 'assets/app/uploads'; }
	@:optional var collection : Collection; // {Mongo.Collection}	Isomorphic	Mongo.Collection Instance		You can pass your own Mongo Collection instance {collection: new Mongo.Collection('myFiles')}
	@:optional var collectionName : String;// {String}	Isomorphic	Collection name	MeteorUploadFiles
	@:optional var continueUploadTTL : String ;// {String}	Server	Time in seconds, during upload may be continued, default 3 hours (10800 seconds)	10800 (3 hours)	If upload is not continued during this time, memory used for this upload will be freed. And uploaded chunks is removed. Server will no longer wait for upload, and if upload will be tied to be continued - Server will return 408 Error (Can't continue upload, session expired. Start upload again.)
	@:optional var ddp : {};// {Object}	Client	Custom DDP connection for Collection. Object returned form DDP.connect()	Meteor (The default DDP connection)
	@:optional var cacheControl : String; // {String}	Server	Set Cache-Control header	public, max-age=31536000, s-maxage=31536000
	// var responseHeaders {Object|Function}	Server	Allows to change default response headers	Default Function	We recommend to keep original function structure, with your modifications, see example altering default headers
	@:optional var throttle : EitherType<Float, Bool>;// {Number|false}	Server	Throttle download speed in bps	false
	@:optional var downloadRoute : String; // {String}	Isomorphic	Server Route used to retrieve files	/cdn/storage
	@:optional var schema : {}; // {Object}	Isomorphic	Collection Schema	Default Schema	For more info read Schema docs
	@:optional var chunkSize : Int; // {Number}	Isomorphic	Upload & Serve (for 206 responce) chunk size	272144
	// var namingFunction {Function}	Isomorphic	Function which returns String	false	Primary sets file name on FS
	// var protected {Boolean|Function}	Isomorphic	Control download flow.

	@:native('public') @:optional var publix : Bool; // {Boolean}	Isomorphic	Allows to place files in public directory of your web-server. And let your web-server to serve uploaded files	false	Important notes:
// /	var onBeforeUpload {Function}	Isomorphic	Callback, triggered right before upload is started on client and right after receiving a chunk on server

//	var onInitiateUpload {Function}	Server	Function which executes on server right before upload is begin and right after onBeforeUpload hook returns true. This hook called only once per upload and fully asynchronous.
//	var onBeforeRemove {Function}	Server	Callback, triggered right before remove file (from Client)
//	var onAfterUpload {Function}	Server	Callback, triggered after file is written to FS
//	var onAfterRemove {Function}	Server	Callback, triggered after file(s) is removed from Collection
//	var onbeforeunloadMessage {String|Function}	Client	Message shown to user when closing browser's window or tab, while upload in the progress	Upload in a progress... Do you want to abort?
	@:optional var allowClientCode : Bool; // {Boolean}	Isomorphic	Allow use remove() method on client	true
	@:optional var debug : Bool; // {Boolean}	Isomorphic	Turn on/of debugging and extra logging	false
	// var interceptDownload {Function}	Server	Intercept download request.
}


typedef WriteOptions = {
	@:optional var fileName: String;// {String} - File name with extension, like name.ext
	@:optional var type: String;// {String} - Mime-type, like image/png
	@:optional var size: Int;// {Number} - File size in bytes, if not set file size will be calculated from Buffer
	@:optional var meta: Dynamic;// {Object} - Object with custom meta-data
	@:optional var userId: String;// {String} - UserId, default null
	@:optional var fileId: String;// {String} - id, optional - if not set - Random.id() will be used
}


/**
 * WIP
 *
 * `meteor add ostrio:files`
 *
 *
 * https://github.com/VeliovGroup/Meteor-Files
 * https://github.com/VeliovGroup/Meteor-Files/wiki
 *
 * FilesCollection
 * @author Matthijs Kamstra aka [mck]
 */
@:native('FilesCollection')
extern class FilesCollection {

	function new(?config:Config);
	function findOne(?selector: Dynamic, ?options:FindOneOptions):FileCursor;// [Isomorphic] - Find one file in FilesCollection
	// https://github.com/VeliovGroup/Meteor-Files/wiki/find
	function find(?selector:EitherType<String, Dynamic>, ?options: FindOptions ):FilesCursor; // [Isomorphic] - Create cursor for FilesCollection

	// @:overload(function(doc:Dynamic, ?opts:InsertOptions, ?callback: Dynamic->String->Void ):String { } ) // requires collections2
	// @:overload(function(doc:Dynamic, ?opts:InsertOptions, ?callback: Dynamic->Void ):String { } ) // requires collections2
	// @:overload(function(doc:Dynamic, ?callback: Dynamic->Void ):String { } )
	// function insert(doc:Dynamic, ?callback: Dynamic->String->Void ):String;
	function insert(settings:SettingsObj, ?autoStart : Bool) : Dynamic; // [Client] - Upload file to server


	// function write(data:Buffer, opts : WriteOptions, ?callback : Dynamic->String->Void, ?proceedAfterUpload:Bool) : FilesCollection; // [Server] - Write Buffer to FS and FilesCollection
	// function load() ;// [Server] - Write file to FS and FilesCollection from remote URL
	// function addFile() ;// [Server] - Add local file to FilesCollection from FS
	// function FileUpload.pipe()

	@:overload(function(selector:EitherType<String, Dynamic>, ?callback: Error->Void) : FilesCollection {})// [Isomorphic] - Remove files from FilesCollection and unlink from FS
	function remove(selector:EitherType<String, Dynamic>, ?callback: Dynamic->Void) : FilesCollection;// [Isomorphic] - Remove files from FilesCollection and unlink from FS

	// function unlink() ;// [Server] - Unlink file from FS
	function link() :Void ;// [Isomorphic] - Generate downloadable link
	var collection : Collection ;// [Isomorphic] - Meteor.Collection instance
	var fileURL: String; // [Client] - Generate downloadable link in template

}
