import templates.*;

class Client {
    static function main() {
        Shared.init();

		Home.init();
		PageTwo.init();
		PageOne.init();
		new ComponentTest().init();
		templates.admin.Login.init();

 		// example how TemplateNames work
		trace(TemplateNames.main);
    }
}