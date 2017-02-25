package meteor.macro;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class AutomaticTemplate {

	public static function build()
	{
		var cwd:String = Sys.getCwd();
		var templateSrcFolder = Path.join([cwd, "src" ,"client", "templates"]);
		var templateDstFolder = Path.join([cwd, "www" ,"client", "templates"]);

		if(FileSystem.exists(templateSrcFolder) && FileSystem.exists(templateDstFolder)){
			generateFromFolder(templateSrcFolder);
		} else {
			Context.warning('you use a different folder structure, so this will not work', Context.currentPos());
		}
	}

	public static function generateFromFolder(folder:String):Void
	{
		var fileNames = FileSystem.readDirectory(folder);
		for (fileName in fileNames)
		{
			if (!FileSystem.isDirectory(folder + '/' + fileName))
			{
				var cleanFileName = fileName.toLowerCase().split('.')[0];
				var templateFile = folder.replace('src','www') + '/' + cleanFileName + '.html';

				// [mck] make sure folders are included in the template name "admin/test.html" becomes "admin_test"
				if(folder.split('templates/')[1] != null){
					cleanFileName = folder.split('templates/')[1] + '_' + cleanFileName;
				}

				var html = '<!--
This html template file is generated on ${Date.now()} from hxmeteor macro.
It\'s the template for "${folder + "/" + fileName}"
Once generated it will not be overwritten.
-->

<template name="$cleanFileName">
	<div class="container">
		<h1>${cleanFileName.toUpperCase()}</h1>
		<p>template for $fileName</p>
	</div>
</template>

';
				// [mck] only if it doesn't exist, generate a template
				if(!FileSystem.exists(templateFile)){
					trace('Created new template: "$templateFile"');
					File.saveContent(templateFile, html);
				}
			} else {
				generateFromFolder(folder + '/' + fileName);
			}
		}
	}

}

#end