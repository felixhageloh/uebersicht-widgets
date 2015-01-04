# Widgets for [Übersicht](http://tracesof.net/uebersicht/)

> UPDATE: widgets now live in their own github repo. The old format is still supported, but will be phased out soon.

Got a widget to share? Great, create a **github repo** for it, then [open an issue here](https://github.com/felixhageloh/uebersicht-widgets/issues) and be sure to mention the url.
It will get picked up ASAP!

### Note:

Since tweaking the look of a widget is fun and easy, the widget gallery is probably the most useful if it serves as starting point instead of being a comprehensive list of all possible widgets. For this reason we try to keep the widget gallery as focused as possible. This means, instead of adding new widgets that are very similar to an existing widget, we try to encourage people to make a pull requests with their improvements (these could be technical improvements or style/design improvements).

## Widget format

Your repo should contain at least these three files:

* `widget.json` a widget manifest
* `<widget-name>.widget.zip` a zip archive containing your widget
* `screenshot.png` an image showing your widget in action

It is also advised that you include an unzipped version of your widget, so that people can view the code and/or issue pull requests with improvements.

### widget.json

A small manifest file that describes your widget. It should have the following format:

    {
      "name": "name of your widget",
      "description": "a short(!) description",
      "author": "your name",
      "email": "your email address"
    }

### widget-name.widget.zip

This is the actual widget, which is a zipped folder with the name of your widget and a .widget extension. The contents of the folder are usually just the .js or .coffee file with your widget code (you can call it anything you like, but index.js/.coffee seems like a good choice). If your widget needs any other assets such as images, fonts or even binaries, you can include them here.


### screenshot

> IMPORTANT: make sure your screen shot is 258x160px (516x320px for hi-res). Otherwise it will get scaled, squashed and/or squeezed in the widgets gallery.

An image file in any web format you like, showing a screen shot of your widget. Currently, screen shots are displayed at 258x160px. For best results you can provide a 516x320px image for retina resolution.

#### Still have questions? You can start by checking existing widgets for examples.

Also visit the [documentation](https://github.com/felixhageloh/uebersicht).
