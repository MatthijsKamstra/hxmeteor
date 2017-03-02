package templates;

import meteor.Template;

class Home {

	public static function init() {

		var _template = Template.get(TemplateNames.home);

		_template.onCreated(function onCreated() {

		});

		_template.helpers({
			test:function (){
				return '**Home**';
			}
		});

		_template.events({
			'click .testBtn':function (event){

				// Prevent default browser form submit
				event.preventDefault();

				trace("click 'Home'");
			}
		});
	}
}