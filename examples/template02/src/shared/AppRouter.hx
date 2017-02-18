import meteor.packages.IronRouter;

class AppRouter {

	static public function init() {
		IronRouter.configure( {
			layoutTemplate:'main', // you could use TemplateNames.main as well
			loadingTemplate:TemplateNames.loading,
		});

		IronRouter.route("/", function() {
			RouterCtx.render(TemplateNames.home);
		});

		IronRouter.route("/one", function() {
			RouterCtx.render("pageone");
		});

		IronRouter.route("/two", function() {
			RouterCtx.render(TemplateNames.pagetwo);
		});

		IronRouter.route("/faq", function() {
			RouterCtx.render(TemplateNames.faq);
		});

		IronRouter.route("/signout", function() {
			RouterCtx.render(TemplateNames.signout);
		});

		IronRouter.route("/test1", function() {
			RouterCtx.render(TemplateNames.one);
		});
		IronRouter.route("/test2", function() {
			RouterCtx.render(TemplateNames.two);
		});
	}

}