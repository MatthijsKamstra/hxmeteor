import templates.*;

class Client {
    static function main() {
        Shared.init();

		Home.init();
		PageTwo.init();
		PageOne.init();
		templates.admin.Login.init();

 		// example how TemplateNames work
		trace(TemplateNames.main);
    }
}