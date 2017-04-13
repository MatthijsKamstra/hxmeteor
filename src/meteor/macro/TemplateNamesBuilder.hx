package meteor.macro;

#if macro

// https://github.com/HaxeFlixel/flixel/blob/74ada1ba7de90f3887c6064531de3be77fabb928/flixel/system/macros/FlxAssetPaths.hx

/**
 * @author Matthijs Kamstra aka [mck]
 * @author Mark Knol [blog.stroep.nl]
 * @author Gama11 (haxeflixel)
 */
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class TemplateNamesBuilder
{


	/**
	 * [build description]
	 * @param  directory      [description]
	 * @param  subDirectories [description]
	 * @return                [description]
	 */
	public static function build(directory:String, subDirectories:Bool = true):Array<Field>
	{
		if (!directory.endsWith("/")) directory += "/";

		var templateReferences:Array<TemplateRef> = getFileReferences(directory, subDirectories);

		var fields:Array<Field> = Context.getBuildFields();

		for (templateRef in templateReferences)
		{
			// trace('${templateRef.fileName}, ${templateRef.templateName}');
			// create new fields based on file references!
			fields.push({
				name: templateRef.name,
				doc: templateRef.documentation,
				// access: [Access.APublic, Access.AStatic],
				access: [Access.APublic, Access.AStatic, Access.AInline],
				kind: FieldType.FVar(macro:String, macro $v{templateRef.templateName}),
				pos: Context.currentPos()
		   });
		}

		// trace(templateReferences.length);

		return fields;
	}


	public static function getFileReferences(directory:String, subDirectories:Bool):Array<TemplateRef>
	{
		var templateReferences:Array<TemplateRef> = [];
		var fileNames = FileSystem.readDirectory(directory);
		for (fileName in fileNames)
		{
			if (!FileSystem.isDirectory(directory + fileName))
			{
				var content = File.getContent (directory + fileName);
				var ereg:EReg = ~/<template\s+name\s*=\s*['"](\w*)['"]\s*>/;
				while (ereg.match(content)) {
					var templateName = (ereg.matched(1));
					content = ereg.matchedRight();

					// check if there are double entries
					// might be from <!--  -->, comment templates
					for (templateRef in templateReferences){
						if(templateRef.name == templateName){
							// trace('this is a problem, fix it');
							//
							//  There are multiple templates named 'thanksPage'. Each template needs a unique name.
							//
							Context.fatalError('Template name "$templateName" is used in file "${templateRef.templateName}" and "${fileName}", make sure it doesn\'t', Context.currentPos());
							// continue;
						}
					}
					// push filenames/templateName in list.
					templateReferences.push(new TemplateRef(fileName, templateName));
				}
			} else {
				templateReferences = templateReferences.concat(getFileReferences(directory + fileName + "/", subDirectories));
			}
		}
		return templateReferences;
	}
}

// internal class
class TemplateRef
{
	public var name:String;
	public var fileName:String;
	public var templateName:String;
	public var documentation:String;

	public function new(fileName:String, templateName:String)
	{
		this.fileName = fileName;
		this.templateName = templateName;

		// replace forbidden characters to underscores, since variables cannot use these symbols.
		this.name = templateName.split("-").join("_").split(".").join("__");

		// generate documentation
		this.documentation = "Ref. to \"" + templateName + "\" template from file \"" + fileName + "\". (auto generated)";
	}
}
#end
