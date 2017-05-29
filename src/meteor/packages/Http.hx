package meteor.packages;

import haxe.Constraints.Function;

typedef HttpOptions = {
	@:optional var content : String; //String to use as the HTTP request body.
	@:optional var data :Dynamic; // JSON-able object to stringify and use as the HTTP request body. Overwrites content.
	@:optional var query : String; //Query string to go in the URL. Overwrites any query string in url.
	@:optional var params : Dynamic; // Dictionary of request parameters to be encoded and placed in the URL (for GETs) or request body (for POSTs). If content or data is specified, params will always be placed in the URL.
	@:optional var auth : String; //HTTP basic authentication string of the form "username:password"
	@:optional var headers : Dynamic; // Dictionary of strings, headers to add to the HTTP request.
	@:optional var timeout : Int; //Maximum time in milliseconds to wait for the request before failing. There is no timeout by default.
	@:optional var followRedirects : Bool ; // If true, transparently follow HTTP redirects. Cannot be set to false on the client. Default true.
	@:optional var npmRequestOptions : Dynamic; // On the server, HTTP.call is implemented by using the npm request module. Any options in this object will be passed directly to the request invocation.
	@:optional var beforeSend : Function; // On the client, this will be called before the request is sent to allow for more direct manipulation of the underlying XMLHttpRequest object, which will be passed as the first argument. If the callback returns false, the request will be not be send.
}


@:enum abstract HttpMethod(String) {
	var GET = 'GET';
	var POST = 'POST';
	var HEAD = 'HEAD';
}


/**
 * HTTP provides an HTTP request API on the client and server.
 *
 * http://docs.meteor.com/api/http.html
 *
 * To use these functions, add the HTTP package to your project by running in your terminal:
 *
 * meteor add http
 */
@:native('HTTP')
extern class Http {
	static function call(method:HttpMethod, url:String, ?options:HttpOptions, ?callback:Dynamic->Dynamic->Void):Dynamic;

	static function get(url:String, ?options:HttpOptions, ?callback:Dynamic->Dynamic->Void):Dynamic;
	static function post(url:String, ?options:HttpOptions, ?callback:Dynamic->Dynamic->Void):Dynamic;
	static function put(url:String, ?options:HttpOptions, ?callback:Dynamic->Dynamic->Void):Dynamic;
	static function del(url:String, ?options:HttpOptions, ?callback:Dynamic->Dynamic->Void):Dynamic;
}