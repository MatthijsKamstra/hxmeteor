# Meteor Haxe Externs

Externs and tools to build [meteor](https://www.meteor.com/) applications using [Haxe](https://www.haxe.org) language.

This is a version that is used in production but the externs might not be complete, also some of the workflows/concepts are subject to change.

Currently up-to-date:

- Meteor 1.4.3.1
- Haxe 3.4.0


##How it works
Meteor.js has a very specific workflow designed for javascript language, some of its features are slightly modified or workaround when using Haxe.

Check out the [example](/examples) folder

- **File Structuring**

Meteor applications distribute client and server code in many source files or a single one for small apps, haxe uses classes that can be compiled to a single file or a client and a server file containing all the application logic. The examples folder contain different approaches.

- **Context / namespace**

In Meteor, the `this` keyword has a different context and properties in callbacks like: `Meteor.publish(), Meteor.method(), template.helpers(), Router.route()`:

```javascript
Template.myTemplate.helpers = {
	firstId:function () {
		return this.firstNode().id;
	}
}

Router.route('/', function () {
  this.render('MyTemplate');
});
```

To mimic these namespaces in a typed manner, context objects like `TemplateCtx`, `PublishCtx`, `MethodCtx` and `RouterCtx` are provided. The example above becomes:

```haxe
Templace.get('myTemplate').helpers = {
	firstId:function () {
		return TemplateCtx.firstNode().id;
	}
}

Route.route('/', function () {
	RouterCtx.render('MyTemplate');
});
```

* **Exposing collections**

In meteor it's common to assign global variables when creating collections, these collections become then available from the browser console.

```javascript
Players = new Mongo.Collection("players");
```

In Haxe its harder to create global variables, a workaround is to assign the collections to the window object.

```haxe
var collection = new Collection("players");
untyped js.Browser.window["Players"] = untyped collection._collection;
```

# Haxelib

How to install Haxe Meteor externs for javascript

```
haxelib install hxmeteor
```

Besides using Haxelib, you can use this git repos as a development directory:

```
haxelib dev hxmeteor path/to/folder
```

or use git directly

```
haxelib git hxmeteor https://github.com/MatthijsKamstra/hxmeteor.git
```

don't forget to add it to your build file

```haxe
-lib hxmeteor
```

### haxelib extra

When you install hxmeteor via haxelib you will also have access to project scaffolding.

You need to have meteor installed for this to work!

Type in you terminal:

```
haxelib run hxmeteor
```

It will generate a Haxe / Meteor folder structure most of the examples are based upon: [scaffold example](/examples/scaffold/)

- `.vscode` folder (no Flashdevelop/Haxedevelop config files yet... )
- `src` and `www` folder (with all the folderstructure to make both of them work)
- an empty meteor project is generated (`meteor create --bare`)
- build (debug/release) files for Haxe and VSCode
- package.json for automatic compilation on save (don't forget to `npm install` before you start)
- some files to get you started

I am pritty sure you should do this only once!




# Haxe macros

A very powerfull feature of Haxe are [macros](https://haxe.org/manual/macro.html) ([API](http://api.haxe.org/haxe/macro/)).

> Macros are without a doubt the most advanced feature in Haxe. They are often perceived as dark magic that only a select few are capable of mastering, yet there is nothing magical (and certainly nothing dark) about them.

### Template name list

With the help of macros you have access to the template names.

Okay, this is an example of an template file in `meteor`:

```html
<template name="foobar">
	...
</template>
```

We want to know the name of this template: "foobar".

Normally you would make a file with static references to the (template)filename:

```haxe
public static inline var FOOBAR : String = "foobar";
```

This works, but the templates names list can become long very fast.
So let a computer do that for use!

> If you want to read more indepth about this type of macro read: [Haxe Macros: Code completion for everything | Blog Mark Knol](http://blog.stroep.nl/2014/01/haxe-macros/)

All you need to create / copy is a `TemplateNames.hx` file (in this repo `src/shared/TemplateNames.hx`):

```haxe
package;
@:build(meteor.macro.TemplateNamesBuilder.build("www/client/templates/"))
class TemplateNames{}
```

And point to the correct template folder, in this case

`"www/client/templates/"`

Type `TemplateNames.` and Visual Studio Code (or HaxeDevelop) will auto complete the template name.

Every time the autocomplete is activated, this macro is executed.
And it will check if the template file has a name.

BIG advantage is:

- autocompletion on "hidden" templates (when two templates included in one file)
- removing files will create an error if that file is used in your code
- renaming templates will create an error
- changing filenames will have no effect (javascript is flexible like that)
- TemplateNames will always be up to date
- warning for double templatesname before runtime


### Automatic generation of html template

With the help of macros we generate templates based on Haxe Classes.

Lets create a Haxe class in the folder `src/client/templates/`:

(it only works in this folder btw)

```haxe
package templates;
import meteor.Template;
class PageOne {

	public static function init()
	{
		var _template = Template.get("pageone");
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
```

We need an template with that (in this case 'pageone');

Lets build that automaticly, add this to your build file:

```
--macro meteor.macro.AutomaticTemplate.build()
```

Now everytime you do a build (or use automatic build) this macro will read folder `src/client/templates/*` (and its subfolders) for classes and will check if folder `www/client/templates/*` has a file corresponding to that class.

In our case it will generate in folder `www/client/templates/*`

```html
<template name="pageone">
	<div class="container">
		<h1>PAGEONE</h1>
		<p>template for PageOne.hx</p>
	</div>
</template>
```

#TODOS
Some ideas for macros and utilities that may improve the haxe-meteor workflow in the future:

* **Typed Collections** like in [haxe-mongoose externs](https://github.com/clemos/haxe-js-kit/blob/master/test/MongooseTest.hx).

* **Expose Collections** to the browser automatically on creation.

* **Context Object** provided in callbacks, (this objects would need to be removed during compile-time using macros) example:

```haxe
Templace.get('myTemplate').helpers = {
	firstId:function (ctx:TemplateCtx) {
		return ctx.firstNode().id;
	}
}

Route.route('/', function (ctx:RouterCtx) {
	ctx.render('MyTemplate');
});
```

* **Templates List** showing available templates and type-check them using macros, something like [in this article](http://blog.stroep.nl/2014/01/haxe-macros/). DONE!

* **ES6 modules** output with [modular-js](https://github.com/kevinresol/modular-js)





