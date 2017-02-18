
import templates.*;

class Client {
    static function main() {
        Shared.init();
		PageTwo.init();
        new Faq().init();

        trace(TemplateNames.main);
    }
}
