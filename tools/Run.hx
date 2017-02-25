package;

import sys.FileSystem;
import sys.io.File;

using StringTools;

class Run {

	var hxFileArray:Array<String> = [];

	var isExpose : Bool = false;
	var isDebug : Bool = false;

	var sourceFolder : String = 'src';
	var exportFolder : String = 'bin';

	var root : Dynamic;

	public function new()
	{
		var args = Sys.args ();
		var current = Sys.getCwd ();

		root = args[args.length-1];

		var folderArr = [
			'/.vscode/',
			'/src/assets',
			'/src/client/templates/admin',
			'/src/client/ui/',
			'/src/client/startup/',
			'/src/server/',
			'/src/shared/utils/',
			'/src/shared/model/constants/',
			'/www/client/templates/admin/',
			'/www/public/fonts/',
			'/www/public/img/',
			'/www/server/'
		];

		// if(args.indexOf('-expose') != -1) 	isExpose = true;
		// if(args.indexOf('-debug') != -1) 	isDebug = true;
		// if(args.indexOf('-help') != -1) 	showHelp();
		// if(args.indexOf('-source') != -1) 	sourceFolder = args[args.indexOf('-source')+1];
		// if(args.indexOf('-export') != -1) 	exportFolder = args[args.indexOf('-export')+1];


		if (!FileSystem.exists('${root}/www/.meteor'))
		{
			// meteor project
			neko.Lib.println('- create meteor project in www');

			var p = new sys.io.Process("meteor", ["create",'--bare','${root}/www/']);

			// read everything from stderr
			var error = p.stderr.readAll().toString();
			neko.Lib.println("stderr:\n" + error);

			// read everything from stdout
			var stdout = p.stdout.readAll().toString();
			neko.Lib.println("stdout:\n" + stdout);

			// close the process I/O
			p.close();
		} else {
			neko.Lib.println('- already meteor project in www');
		}




		// build all folders
		neko.Lib.println('- hxmeteor scaffold');
		for (i in 0 ... folderArr.length) {
			neko.Lib.println('   * create folder "${folderArr[i]}"');
			FileSystem.createDirectory(root + folderArr[i]);
		}

		// vscode
		neko.Lib.println('- VSCode stuff');
		File.saveContent(root+'/.vscode/settings.json','{\n\t"haxe.displayConfigurations": [\n\t\t[\n\t\t\t"build_vscode.hxml"\n\t\t]\n\t]\n}');
		File.saveContent(root+'/.vscode/tasks.json', haxe.Resource.getString("task-template"));

		neko.Lib.println('- NPM install stuff');
		File.saveContent(root+'/package.json', haxe.Resource.getString("package-template"));
		// use command line

		// [mck] something weird going on...

		// new sys.io.Process("cd", ['${root}/']);
		// var p = new sys.io.Process("ls", []);

		// var p = new sys.io.Process("npm", ["install"]);

		// // read everything from stderr
		// var error = p.stderr.readAll().toString();
		// neko.Lib.println("stderr:\n" + error);

		// // read everything from stdout
		// var stdout = p.stdout.readAll().toString();
		// neko.Lib.println("stdout:\n" + stdout);
		// p.close();

		// build files
		neko.Lib.println('- haxe build (hxml)');
		File.saveContent(root+'/build.hxml', createHxml('debug'));
		File.saveContent(root+'/build_release.hxml',createHxml('release'));
		File.saveContent(root+'/build_vscode.hxml','# build file used for VSCode.\n-lib hxmeteor\n-cp src/shared\n-cp src/client\n-main Client\n-js www/client/client.js\n-dce full\n-debug');

		// misc
		neko.Lib.println('- readme and todo');
		File.saveContent(root+'/README.MD','#README\n\n

Automated build with terminal (after you installed NPM)

```
npm install
npm run watch
```

To run your new meteor app:

```
cd www
meteor npm install
meteor
```

');
		File.saveContent(root+'/TODO.MD','#TODO\n\n');

		// templates
		neko.Lib.println('- templates stuff');
		File.saveContent(root+'/src/assets/test.mtt','<b>::test::</b>');

		// files
		neko.Lib.println('- hx files stuff');
		File.saveContent(root+'/src/client/Client.hx','import templates.*;

class Client {
    static function main() {
        Shared.init();

		PageTwo.init();
		PageOne.init();
		templates.admin.Login.init();

 		// example how TemplateNames work
		trace(TemplateNames.main);
    }
}');
		File.saveContent(root+'/src/server/Server.hx','import meteor.Meteor;
import model.Tasks;

class Server {
    static function main() {
        Shared.init();

		Meteor.publish(\'tasks\', function () {
			return Tasks.collection.find();
		});
    }
}
');
		File.saveContent(root+'/src/shared/Shared.hx','package;\n\nclass Shared {\n\tstatic public function init() {\n\t\tAppRouter.init();\n\t}\n}');
		File.saveContent(root+'/src/shared/AppRouter.hx','import meteor.packages.IronRouter;

import js.Browser.*;

class AppRouter {

	static public function init() {

		IronRouter.configure( {
			layoutTemplate:\'main\',
			loadingTemplate:\'loading\',
		});

		IronRouter.route("/", function() {
			RouterCtx.render(\'home\');
		});
		IronRouter.route("/pageone", function() {
			RouterCtx.render(\'pageone\');
		});
		IronRouter.route("/pagetwo", function() {
			RouterCtx.render(\'pagetwo\');
		});
	}
}');

		File.saveContent(root+'/src/shared/model/Tasks.hx','package model;
import meteor.Collection;

class Tasks {

	public static var collection:Collection;
	public static function init() {
		collection = new Collection("Tasks");
	}

}');

		File.saveContent(root+'/src/shared/TemplateNames.hx','package;
@:build(meteor.macro.TemplateNamesBuilder.build("www/client/templates/"))
class TemplateNames{}');


		File.saveContent(root+'/www/client/templates/main.html','<template name="main">test</template>');


		createTemplate('/src/client/templates/','PageOne');
		createTemplate('/src/client/templates/','PageTwo');
		createTemplate('/src/client/templates/admin/','Login');




	}

	function createTemplate(path:String,className:String):Void {
		neko.Lib.println('    * create "$className".hx');
		var temp = path.split('/templates/')[1].replace("/","");
		var packageName = 'templates';
		if(temp.length != 0) packageName += '.$temp';
		var templateName = className.toLowerCase();
		var str = haxe.Resource.getString("classname-template");
		var template = new haxe.Template(str);
		var obj = {
			className:className,
			packageName:packageName,
			templateName:templateName
		};
		var output = template.execute(obj);
		File.saveContent(root+path+'$className.hx',output);
	}

	function createHxml(type:String):String {
		var comment = '# ';
		if(type == 'debug') comment = '';
		var str = haxe.Resource.getString("buildextra-template");
		var template = new haxe.Template(str);
		var obj = {
			comment:comment,
			type:type
		};
		var output = template.execute(obj);
		return output;
	}



	function showHelp(){
		Sys.println('[fixme]');
	}

	static public function main() { var app = new Run();}

}

