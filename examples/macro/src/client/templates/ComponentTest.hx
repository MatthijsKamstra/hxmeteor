package templates;

@:templateFile('templates/assets/counter.html')
@:cssFile('templates/assets/counter.css')
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
		// your code
	}
}