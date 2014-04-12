# Widgets for [Übersicht](http://tracesof.net/uebersicht/)


Got a widget to share? Great, please issue a pull request and it will get picked up ASAP! Visit the [documentation](https://github.com/felixhageloh/uebersicht) for details on how to write your own widget.

## Widget format

Your submitted widget should be a single folder, containing:

* `widget.json` a widget manifest
* `<widget-name>.widget.zip` a zip archive containing your widget
* `screenshot.png` an image showing your widget in action

It is also advised that you include an unzipped version of your widget, so that people can view the code.


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

An image file in any web format you like, showing a screen shot of your widget. Currently, screen shots are displayed at 258x160px. For best results you can provide a 516x320px image for retina resolution.

#### Still have questions? You can start by checking existing widgets for examples.
