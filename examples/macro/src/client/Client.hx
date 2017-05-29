import templates.*;
import templates.component.*;

class Client {
    static function main() {
        Shared.init();

		Home.init();
		PageTwo.init();
		PageOne.init();
		templates.admin.Login.init();

		// components
		new Css().init();
		new CssTemplate().init();
		// new Html().init();
		// new HtmlTemplate().init();
		// new Combine().init();
		new ComponentTest().init();
		new Inline().init();

 		// example how TemplateNames work
		trace(TemplateNames.main);
    }
}