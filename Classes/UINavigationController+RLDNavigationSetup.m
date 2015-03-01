#import "UINavigationController+RLDNavigationSetup.h"

#import "RLDNavigationSetup.h"

@interface UIViewController (RLDNavigationSetup)

- (BOOL)isDestinationOfNavigationSetup:(RLDNavigationSetup *)navigationSetup;

@end

@implementation UINavigationController (RLDNavigationSetup)

- (UIViewController *)viewControllerForNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    UIViewController *viewControllerToReturnTo = nil;
    
    for (UIViewController *viewController in [self.viewControllers reverseObjectEnumerator]) {
        if ([viewController isDestinationOfNavigationSetup:navigationSetup]) {
            viewControllerToReturnTo = viewController;
            break;
        }
    }
    
    return viewControllerToReturnTo;
}

@end

@implementation UIViewController (RLDNavigationSetup)

- (BOOL)isDestinationOfNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    if (![self isKindOfClass:navigationSetup.destination]) return NO;
    
    __block BOOL isDestinationViewController = YES;
    [navigationSetup.properties enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        @try {
            if (![[self valueForKey:key] isEqual:value]) {
                isDestinationViewController = NO;
                *stop = YES;
            }
            
        } @catch (NSException *exception) {}
    }];
    return isDestinationViewController;
}

@end