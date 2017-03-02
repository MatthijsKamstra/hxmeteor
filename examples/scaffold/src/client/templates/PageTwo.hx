package templates;

import meteor.Template;

class PageTwo {

	public static function init() {

		var _template = Template.get(TemplateNames.pagetwo);

		_template.onCreated(function onCreated() {

		});

		_template.helpers({
			test:function (){
				return '**PageTwo**';
			}
		});

		_template.events({
			'click .testBtn':function (event){

				// Prevent default browser form submit
				event.preventDefault();

				trace("click 'PageTwo'");
			}
		});
	}
}