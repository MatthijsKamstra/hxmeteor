package meteor;

@:autoBuild(meteor.macro.TemplateBuilder.build())
class MeteorComponent {
	public function template():String;
}