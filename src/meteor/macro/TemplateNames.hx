package meteor.macro;
/**
 *  Get template names with macros: template-files in `www/client/templates`
 */
@:build(meteor.macro.TemplateNamesBuilder.build("www/client/templates/"))
class TemplateNames
{
   // Ha! Nothing in here!
}
