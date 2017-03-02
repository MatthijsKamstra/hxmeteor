package templates;

import meteor.Template;

class PageOne {

	public static function init() {

		var _template = Template.get(TemplateNames.pageone);

		_template.onCreated(function onCreated() {

		});

		_template.helpers({
			test:function (){
				return '**PageOne**';
			}
		});

		_template.events({
			'click .testBtn':function (event){

				// Prevent default browser form submit
				event.preventDefault();

				trace("click 'PageOne'");
			}
		});
	}
}