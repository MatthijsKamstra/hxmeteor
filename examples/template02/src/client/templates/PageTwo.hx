package templates;
import meteor.Template;

class PageTwo {

	public static function init() {

		Template.get('pagetwo').helpers( {

		});

		Template.get('pagetwo').events( {

			"submit .new-task": function (event) {
				event.preventDefault();
				var text = event.target.text.value;



				// Clear form
				event.target.text.value = "";
			},


			"click .btn-danger": function (event) {

			}

		});

	}
}