package templates.admin;

import meteor.Template;

class Login {

	public static function init() {

		var _template = Template.get(TemplateNames.admin_login);

		_template.onCreated(function onCreated() {

		});

		_template.helpers({
			test:function (){
				return '**Login**';
			}
		});

		_template.events({
			'click .testBtn':function (event){

				// Prevent default browser form submit
				event.preventDefault();

				trace("click 'Login'");
			}
		});
	}
}