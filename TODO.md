
# template

https://github.com/skial/fe
https://github.com/MarcWeber/haxe-macro-html-templates
https://github.com/benmerckx/ithril
https://github.com/fponticelli/doom
https://github.com/skial/fe
https://github.com/MarcWeber/haxe-html





```
Meteor server restarted
=> Errors prevented startup:

   While processing files with templating-compiler (for target
   web.browser):
   client/templates/admin/userlist.html:54: Expected "tbody" end
   tag
   ...ody>-->                     </table>
   </div>                 <p...
   ^

=> Your application has errors. Waiting for file change.
```





    var h:String = untyped js.Lib.window.hello;

Or you could also use Reflect

    var h = Reflect.field(js.Lib.window, "hello");



var collection = new Collection("players");
untyped js.Browser.window["Players"] = untyped collection._collection;


```haxe
package model;

import meteor.Meteor;
import meteor.Collection;

class Timeslots {

	public static var collection:Collection;
	public static function init() {
		collection = new Collection(model.constants.ModelName.TIMESLOTS);

		#if debug
		// server doesn't have a window, so this is only needed for the client
		if(Meteor.isClient) untyped js.Browser.window[model.constants.ModelName.TIMESLOTS] = untyped collection._collection;
		#end
	}

}
```