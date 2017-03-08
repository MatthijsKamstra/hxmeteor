import meteor.packages.IronRouter;

import js.Browser.*;

class AppRouter {

	static public function init() {

		IronRouter.configure( {
			layoutTemplate:'main',
			loadingTemplate:'loading',
		});

		IronRouter.route("/", function() {
			RouterCtx.render('home');
		});
		IronRouter.route("/pageone", function() {
			RouterCtx.render('pageone');
		});
		IronRouter.route("/pagetwo", function() {
			RouterCtx.render('pagetwo');
		});
	}
}