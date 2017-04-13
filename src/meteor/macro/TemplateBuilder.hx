package meteor.macro;

#if macro

import haxe.io.Path;

import haxe.macro.Context;
import haxe.macro.Expr;

import sys.FileSystem;
import sys.io.File;
import sys.io.File;

using tink.macro.Metadatas;
using tink.MacroApi;
using Lambda;
using StringTools;
using TemplateBuilder.Helper;
using haxe.macro.ExprTools;

class Helper {
	public inline static function cleanupTemplate(template:String )
		return template
			.replace("'","")
			.replace("  "," ")
			.replace('\\"','"')
			.replace("\n","")
			.replace("\t","")
			.replace("\r","")
			.replace("\\n","")
			.replace("\\t","")
			.replace("\\r","");
}


/**
 *  TemplateBuild
 *
 *  @source https://github.com/francescoagati/riot.hx/blob/master/src/riot/RiotBuilder.hx
 */
class TemplateBuilder {

	private static var WARNING : String = '<!--
This html template file is generated on ${Date.now()} with hxmeteor IMeteorComponent macro.

- Resistance is futile
- Remove this file and next time Haxe Compiler builds, it will be back
- Find a Haxe expert if you don\'t know what to do
-->

';

	/**
	 *  [Description]
	 *  @param path -
	 */
	inline static function loadFileAsString(path:String) {
		try {
			var p = haxe.macro.Context.resolvePath(path);
			return sys.io.File.getContent(p);
		} catch(e:Dynamic) {
			throw 'error load file $path';
			return haxe.macro.Context.error('Failed to load file $path: $e', Context.currentPos());
		}
	}

	/**
	 *  [Description]
	 *  @param meta -
	 *  @param annotationFile -
	 *  @param annotationInline -
	 *  @return String
	 */
	inline static function getTemplateFromAnnotation( meta:Map<String, Array<Array<Expr>>>, annotationFile:String, annotationInline:String):String {

		if (meta.exists(annotationFile)) {
			var filePaths = [ for (mt in meta.get(annotationFile)) mt[0].toString().replace("'","") ];
			// return [for (filePath in filePaths) loadFileAsString(filePath).cleanupTemplate()].join("");
			return [for (filePath in filePaths) loadFileAsString(filePath)].join("");
		}

		if (meta.exists(annotationInline)) {
			// var content = meta.get(annotationInline)[0][0].toString().cleanupTemplate();
			var content = meta.get(annotationInline)[0][0].toString();
			return content;
		}
		return "";
	}

	/**
	 *  [Description]
	 *  @return Array<Field>
	 */
	public static function build():Array<Field>{

		var fields = Context.getBuildFields();

		var cls = Context.getLocalClass().get();
	    var meta = cls.meta.get().toMap();

	    // trace(meta);
		// trace(cls);
		// trace(Context.getLocalModule());

		var template = getTemplateFromAnnotation(meta,':templateFile',':template');
		var cssFile  = getTemplateFromAnnotation(meta,':cssFile',':css').cleanupTemplate();

		// var x : haxe.macro.Expr = (meta.get(':templateFile')[0][0]);
		// trace(x.toString());

		// var pack : Array<String> = cls.pack;

		// trace(pack);

		var arr = ['www', 'client'];
		for ( i in cls.pack )arr.push(i);
		var temp = arr.copy();
		arr.push('${cls.name.toLowerCase()}.html');
		temp.push('_${cls.name.toLowerCase()}.html');

		var templatePath : String = Path.join(arr);
		var tempPath : String = Path.join(temp);


		// trace(tempPath);

		// Sys.println('------');
		// Sys.println('$template');
		// Sys.println('------');
		// Sys.println('$cssFile');
		// Sys.println('------');

		template = WARNING + template;

		// [mck] make sure the templates generated with AutomaticTemplate are removed
		if(FileSystem.exists(tempPath)) {
			Sys.println('removing temp template $tempPath');
			FileSystem.deleteFile(tempPath);
		}
		File.saveContent(templatePath, template);

		// trace('$fields');
		return fields;
	}

}
#end