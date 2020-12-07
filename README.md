# Pete's Quotes

This repository contains an Xcode project for an app and its widget called "Pete's Quotes". The app uses a free famous quote service to display the quotation and author as a widget. Once the quotes are fetched, the widget randomly displays one every so often (as set by the app).

Unlike most apps, the focus here is on the widget. The app just provides some customization of the widget. If you want to add a widget to your app, this is a good place to start as I cover the basics.

> You can find out more on my blog at https://www.keaura.com/blog/widgets-with-swiftui.

The project has two targets: the app and the widget. This project shows you:

* How to create a widget target in your project.
* How to share code between your app and your widget.
* How to share data between your app and your target.
* How to support different widget sizes.
* How to make remote calls from a widget.
* A tip about a bug or two you are likely to encounter.

You will need Xcode 12.2 and a device running iOS 14. You can use the simulators but I've found it more reliable to run on an actual device.

The app and widget use Alamofire to handle the remote call and data; you can use URLSession if you prefer. It is only a single call and response. I just using Alamofire.

Once you've got the project and built it, you run the widget using its own Xcode scheme, `PetesQuotes_WidgetExtension`. This will install the widget in the simulator or device. You can stop the task once it has been started.

Give the blog article a read to get more insight.
