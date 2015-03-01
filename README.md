# RLDNavigation

If you want to adhere to the single responsibility principle of object-oriented programming, your view controllers shouldn't be taking care of the navigation flow of your app.

`RLDNavigation` is a set of classes which allow you to decouple navigation from view controllers, using navigation command objects to define the possible navigation flows of your app.

It implements routing using an [algorithm](http://en.wikipedia.org/wiki/Breadth-first_search) to resolve complex paths. It also prevents navigation cycles like `A > B > C > B`. A sample app is included.

## How to use

### Environment setup

The easiest setup involes subclassing `RLDPushPopNavigationCommand` for each of the view controllers of your app, defining the possible flows that can lead to that view controller and how to initialize it from a storyboard, by overriding these class methods: 

```objectivec
+ (NSArray *)origins;
+ (Class)destination;
+ (NSString *)viewControllerStoryboardIdentifier;
+ (NSString *)nibName; // Defaults to @"Main"
```

You can implement more advanced navigation commands by creating new classes conforming to the `RLDNavigationCommand` protocol or subclassing the homographic class.

### Navigating between view controllers

#### Basic navigation

Once you have all the navigation commands that you need, you will be able to easily navigate from one view controller to another:

```objectivec
#import "RLDNavigation.h"
...

Class classOfDestinationViewController = NSClassFromString(@"ViewControllerClass");
UINavigationController *navigationController = self.navigationController;

[[RLDNavigationSetup setuptWithDestination:classOfDestinationViewController
                      navigationController:navigationController] go];

```

#### Setting up the view controllers

If you need to pass parameters or customize the view controllers when navigating to them, you can specify a dictionary of properties, and [KVC](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/BasicPrinciples.html#//apple_ref/doc/uid/20002170-178791) will be used to try to set all properties for every newly instantiated view controller in the navigation chain. 

For instance, if three view controllers are pushed when navigating in this example, all of them will get its `userName` property set to `John Doe`. If case any of the view controllers doesn't have this property, it will be ignored:

```objectivec
[[RLDNavigationSetup setuptWithDestination:classOfDestinationViewController
                                properties:@{@"userName" : @"John Doe"}
                      navigationController:navigationController] go];
```

#### Breadcrumbs

You can override the fully automatic flow calculation by specifying intermediate destinations that must be reached before aiming to the final target. Automated paths will be followed between these milestones when necessary.

```objectivec
[[RLDNavigationSetup setuptWithDestination:classOfDestinationViewController
                                properties:@{@"userName" : @"John Doe"}
                               breadcrumbs:@(firstIntermediateClass, secondIntermediateClass)
                      navigationController:navigationController] go];
```

Breadcrumbs can help you creating complex routes, and are also a helpful way to replace URL-like navigation definitions.

## Installing

### Using CocoaPods

1. Include the following line in your `Podfile`:
   ```
   pod 'RLDNavigation', :git => 'https://github.com/rlopezdiez/RLDNavigation'
   ```
2. Run `pod install`

### Manually

1. Clone, add as a submodule or [download.](https://github.com/rlopezdiez/RLDNavigation/zipball/master)
2. Add all the files under `Classes` to your project.
3. Make sure your project is configured to use ARC.

## License

`RLDNavigation` is available under the Apache License, Version 2.0. See LICENSE file for more info.

> This README has been made with [(GitHub-Flavored) Markdown Editor](http://jbt.github.io/markdown-editor)