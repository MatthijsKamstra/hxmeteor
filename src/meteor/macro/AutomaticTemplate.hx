package meteor.macro;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class AutomaticTemplate {

	public static function build(prefix:String = '_')
	{
		var cwd:String = Sys.getCwd();
		var templateSrcFolder = Path.join([cwd, "src" ,"client", "templates"]);
		var templateDstFolder = Path.join([cwd, "www" ,"client", "templates"]);

		if(FileSystem.exists(templateSrcFolder) && FileSystem.exists(templateDstFolder)){
			generateFromFolder(templateSrcFolder, prefix);
		} else {
			Context.warning('You might be using a different folder structure: this will not work!', Context.currentPos());
		}
	}

	public static function generateFromFolder(folder:String, prefix:String):Void
	{
		var fileNames = FileSystem.readDirectory(folder);
		for (fileName in fileNames)
		{
			if (!FileSystem.isDirectory(folder + '/' + fileName))
			{
				// ignore invisible (OSX) files like ".DS_Store"
				if (fileName.startsWith(".")) continue;

				var cleanFileName = fileName.toLowerCase().split('.')[0];
				var templateFile = folder.replace('src','www') + '/' + cleanFileName + '.html';
				var tempTemplateFile = folder.replace('src','www') + '/$prefix' + cleanFileName + '.html';

				// [mck] make sure folders are included in the template name "admin/test.html" becomes "admin_test"
				if(folder.split('templates/')[1] != null){
					cleanFileName = folder.split('templates/')[1].replace('/','_') + '_' + cleanFileName;
				}

				var html = '<!--
This html template file is generated on ${Date.now()} from hxmeteor AutomaticTemplate macro.
It\'s the template for "${"src" + folder.split('src')[1] + "/" + fileName}"

- Current filename starts with an "$prefix" to indicate a generated file, you should rename the file once you modified it
- This comment can also be removed, it\'s just to inform you
- Once generated it will not be overwritten (with or without "$prefix")
- Delete this file it will be generated again ("${prefix}foobar.html")
- Unless the same file without "$prefix" is in place ("foobar.html")
-->

<template name="$cleanFileName">
	<!-- Start template: $cleanFileName -->
	<div class="container">
		<h1>${cleanFileName.toUpperCase()}</h1>
		<p>template for $fileName</p>
		<p>test: {{test}}</p>
		<button class="testBtn">click</button>
	</div><!-- /.container -->
</template>

';
				// [mck] only if it doesn't exist, generate a template
				if(!FileSystem.exists(templateFile)){
					if(!FileSystem.exists(tempTemplateFile)){
						trace('Created new template: "$tempTemplateFile"');
						File.saveContent(tempTemplateFile, html);
					}
				}
			} else {
				FileSystem.createDirectory(folder.replace('src','www') + '/' + fileName + '/');
				generateFromFolder(folder + '/' + fileName, prefix);
			}
		}
	}

}

#end