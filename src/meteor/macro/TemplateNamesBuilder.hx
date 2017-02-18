package meteor.macro;

/**
 * @author Matthijs Kamstra aka [mck]
 * @author Mark Knol [blog.stroep.nl]
 */
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;

class TemplateNamesBuilder
{
    public static function build(directory:String):Array<Field>
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
                    // push filenames/templateName in list.
                    templateReferences.push(new TemplateRef(fileName, templateName));
                }
            }
        }

        var fields:Array<Field> = Context.getBuildFields();
        for (templateRef in templateReferences)
        {
            // create new fields based on file references!
            fields.push({
                name: templateRef.name,
                doc: templateRef.documentation,
                access: [Access.APublic, Access.AStatic, Access.AInline],
                kind: FieldType.FVar(macro:String, macro $v{templateRef.templateName}),
                pos: Context.currentPos()
           });
        }

        return fields;
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
        this.documentation = "Reference to template \"" + templateName + "\" from file on disk \"" + fileName + "\". (auto generated)";
    }
}

