package templates.component;

@:templateFile('templates/component/assets/counter.html')
@:cssFile('templates/component/assets/counter.css')
@:template('
	<tempate name="test">
		<h1 class="title">test</h1>
	</template>
')
@:css('
	.title {
		background:yellow;
		color:blue;
	}
')
class ComponentTest implements meteor.IMeteorComponent{
	public function new () {
		// your code
	}

	public function init()
	{
		trace(template);
	}

	public function template():String
	{
		return '<template>test</temlate>';
	}
}