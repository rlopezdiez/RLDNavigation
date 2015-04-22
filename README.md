# RLDNavigation

If you want to adhere to the single responsibility principle of object-oriented programming, your view controllers shouldn't be taking care of the navigation flow of your app.

`RLDNavigation` is a set of classes which allow you to decouple navigation from view controllers, using navigation command objects to define the possible navigation flows of your app.

It implements routing using breadth-first search to resolve complex paths. It also prevents navigation cycles like `A > B > C > B`. A sample app is included.

> [Swift version](https://github.com/rlopezdiez/RLDNavigationSwift) also available.

## How to use

### Environment setup

The easiest setup involves subclassing `RLDPushPopNavigationCommand` for each of the `destination` view controllers of your app, defining the possible flows that can lead to that view controller and how to initialize it, by overriding these class methods: 

```objectivec
+ (NSArray *)origins;
+ (Class)destination;
+ (NSString *)viewControllerStoryboardIdentifier;
+ (NSString *)nibName; // Defaults to @"Main"
```

You should return in `origins` an array of all the view controller classes that can lead to the one referred by the navigation command in `destination`. If you return an empty array or `nil`, the `destination` view controller class will be accessible from any other view controller.

If your navigation command doesn't implement `viewControllerStoryboardIdentifier` and `nibName`, the view controller will be initialised by allocating it and calling its `init` method.

You can implement more advanced navigation commands by creating new classes conforming to the `RLDNavigationCommand` protocol or by subclassing the class cluster with the same name.

### Navigating between view controllers

#### Basic navigation

Once you have all the navigation commands that you need, you will be able to easily navigate from one view controller to another:

```objectivec
#import "RLDNavigation.h"
...

Class classOfDestinationViewController = NSClassFromString(@"ViewControllerClass");

[self goToDestination:classOfDestinationViewController];

```

If you need to be informed when you navigation has finished, you can use `goWithCompletionBlock`, as in this example:
```objectivec
[self goToDestination:classOfDestinationViewController] completionBlock:^{
    // This will be executed once the navigation has taken place
}];
```

#### Setting up the view controllers

If you need to pass parameters or customize the view controllers when navigating to them, you can specify a dictionary of properties, and [KVC](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/BasicPrinciples.html#//apple_ref/doc/uid/20002170-178791) will be used to try to set all properties for every newly instantiated view controller in the navigation chain. 

For instance, if three view controllers are pushed when navigating in this example, all of them will get its `userName` property set to `John Doe`. In case any of the view controllers doesn't have this property, or it's readonly, it will be ignored:

```objectivec
[self goToDestination:classOfDestinationViewController properties:@{@"userName" : @"John Doe"}];
```

#### Breadcrumbs

You can override the fully automatic flow calculation by specifying intermediate destinations that must be reached before aiming to the final target. Automated paths will be followed between these milestones when necessary.

```objectivec
[self goToDestination:classOfDestinationViewController
           properties:@{@"userName" : @"John Doe"}
          breadcrumbs:@(firstIntermediateClass, secondIntermediateClass)];
```

Breadcrumbs can help you creating complex routes, and are also a helpful way to replace URL-like navigation definitions.

#### View models

Instead of exposing your view controller classes, you should consider using view models, which is a cleaner, more flexible and strongly typed way to pass configuration parameters around. This will require a little more effort from your side if your application is not architected to work that way, but will probably pay off in the long term. You can find how to use view models with `RLDNavigation` in the included sample app:
```objectivec
// RLDMenuViewController
- (IBAction)contactCardTapped {
    RLDContactCardViewModel *viewModel = [RLDContactCardViewModel viewModelWithName:@"John"
                                                                            surname:@"Doe"
                                                                              email:@"john.doe@example.com"];
    [[RLDNavigationSetup setupWithViewModel:viewModel
                       navigationController:self.navigationController] go];
}
```

#### URL navigation

In the unlikely event that you want to use an URL-like navigation scheme, you can easily implement it with `RLDNavigation`. Just create a category on `RLDNavigationSetup` and implement a factory method to convert the URL components into breadcrumbs, and the final query into properties. You can find an basic example of how to do this in the included app:

```objectivec
// RLDMenuViewController
- (IBAction)profileTapped {
    [[RLDNavigationSetup setupWithUrl:@"folder/profile?userId=2" navigationController:self.navigationController] go];
}
```

#### Registering navigation commands

`RLDNavigationCommand` is a class cluster. When you call its factory method `navigationCommandWithNavigationSetup:` it will choose the navigation command class or chain of classes needed to navigate to the specified destination, creating the needed instances and calling their `execute` methods one after another. To be able to do this, `RLDNavigationCommand` needs to know all the available classes conforming to the `RLDNavigationCommand` protocol.

By default, the first time you call the `execute` method of an instance of `RLDNavigationCommand`, it will analyse all the loaded classes, registering only the suitable ones. This can be quite time consuming, given that more than 4,000 clases are usually loaded at runtime.

If you are concerned about performance, instead of using this automatic discovery system you can manually register your `RLDNavigationCommand` compliant classes using the category `RLDNavigationCommand+NavigationCommandRegister`. Once a class has been registered in such way, `RLDNavigationCommand` will understand that you have opted out of the automatic class discovering mechanism, and won't try to find new classes by itself. 

When using manual registering, the best way to make sure all your classes are ready when needed is registering them in their `load` method. The included sample app implements this approach:

```objectivec
#import "RLDNavigationCommand+NavigationCommandRegister.h"
...

+ (void)load {
    [self registerCommandClass];
}

```

## Installing

### Using CocoaPods

To use the latest stable release of `RLDNavigation`, just add the following to your project `Podfile`:

```
pod 'RLDNavigation', '~> 0.6.0' 
```

If you like to live on the bleeding edge, you can use the `master` branch with:

```
pod 'RLDNavigation', :git => 'https://github.com/rlopezdiez/RLDNavigation'
```

### Manually

1. Clone, add as a submodule or [download.](https://github.com/rlopezdiez/RLDNavigation/zipball/master)
2. Add all the files under `Classes` to your project.
3. Enjoy.

## License

`RLDNavigation` is available under the Apache License, Version 2.0. See LICENSE file for more info.

This README has been made with [(GitHub-Flavored) Markdown Editor](http://jbt.github.io/markdown-editor)