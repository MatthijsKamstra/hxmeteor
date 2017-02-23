# Haxe Meteor project

- example shows the `TemplateNames` macro
- extra files for VSCode (Visuale Studio Code)
	- most important the `build.hxml` because of the limitations of VSCode
- automatic build via `NPM`
	- use the `build_release.hxml` for that

## how does it work?

check `src/client/Client.hx` and `src/shared/AppRouter.hx` for example code...


All you need to create / copy is a `TemplateNames.hx` file (in this repo `src/shared/TemplateNames.hx`):

```
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


## auto compile

Let NPM auto compile you code on changing `.hx` files

```
cd path/to/folder
npm install
npm run watch
```

start Meteor

```
cd path/to/folder/www
metero
```
