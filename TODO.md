
# template

- <https://github.com/skial/fe> (Create Html from a small subset of Haxe that resembles CSS selectors.)
- <https://github.com/MarcWeber/haxe-macro-html-templates> (haml style macro)
- <https://github.com/benmerckx/ithril> (strange syntax)
- <https://github.com/ciscoheat/mithril-hx> (closer to what I want)
- <https://github.com/fponticelli/doom>
- <https://github.com/MarcWeber/haxe-html> (parser?)


# Template engine

Output

```html
<template name="pageone">
  <div class="container">
    <h1>PAGEONE</h1>
    <p>template for PageOne.hx</p>
    <p>test: {{test}}</p>
    <button class="testBtn">click</button>
  </div>
</template>

```


What would I prefer

```haxe
template(["name"=>"pageone"],[
  div(["class"=>'container'],[
    h1("PAGEONE")
    p("template for PageOne.hx")
    p("test: {{test}}")
    button(["class"=>"testBtn","text"=>"click"])
  ])
]);
```
**PRO**

- not every attribute needs to be defined

**CON**:

- autocompletion not working
- nesting
- no validation in elements (```<button foo="kaas"></button>```)

or

```haxe
template({name:"pageone"},[
  div({class:'container'},[
    h1("PAGEONE")
    p("template for PageOne.hx")
    p("test: {{test}}")
    button({class:"testBtn",text:"click"})
  ])
]);
```

**PRO**:

- validation
- autocompletion
- not every attribute needs to be defined {"foo":"bar"}

**CON**

- nesting

or



# html validator?

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