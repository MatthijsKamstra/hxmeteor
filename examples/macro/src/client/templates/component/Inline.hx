package templates.component;


class Inline extends meteor.MeteorComponent{
	public function new () {
		// your code
	}

	public function init()
	{
		trace(templatez);
	}

	public function templatez():String
	{
		return '<template>test</temlate>';
	}
}