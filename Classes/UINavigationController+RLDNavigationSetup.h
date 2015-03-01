#import <UIKit/UIKit.h>

@class RLDNavigationSetup;

@interface UINavigationController (RLDNavigationSetup)

- (UIViewController *)viewControllerForNavigationSetup:(RLDNavigationSetup *)navigationSetup;

@end