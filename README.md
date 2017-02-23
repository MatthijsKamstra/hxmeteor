# Meteor Haxe Externs

Externs and tools to build [meteor](https://www.meteor.com/) applications using [Haxe](https://www.haxe.org) language.

This is a version that is used in production but the externs might not be complete, also some of the workflows/concepts are subject to change.

Currently up-to-date:

- Meteor 1.4.2.3.
- Haxe > 3.2.0


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

##TODOS
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


# Template list

With the help of macros you have access to the template names

All you need to create / copy is a `TemplateNames.hx` file (in this repo `src/shared/TemplateNames.hx`):

```haxe
package;
@:build(meteor.macro.TemplateNamesBuilder.build("www/client/templates/"))
class TemplateNames{}
```

Where you change the path to the correct template folder, in this case

`"www/client/templates/"`

Type `TemplateNames.` and Visual Studio Code (or HaxeDevelop) will auto complete the template name.


Every time the autocomplete is activated, this macro is executed.
And it will check if the template file has a name

```
<template name="foobar">
	...
</template>
```

BIG advantage is:

- "hidden" templates (when two templates are added in one file)
- removing files will create an error if that file is used in your code
- renaming templates will create an error
- changing filenames will have no effect



#Haxelib

how to use

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


