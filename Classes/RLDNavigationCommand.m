#import "RLDNavigationCommand.h"

#import "RLDNavigationSetup.h"

#import "RLDBreadcrumbNavigationCommand.h"
#import "RLDDirectNavigationCommand.h"
#import "UINavigationController+RLDNavigationSetup.h"

@implementation RLDNavigationCommand

@synthesize navigationSetup = _navigationSetup;

#pragma mark - Factory method

+ (instancetype)navigationCommandWithNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    // We check if we are already at the destination
    UIViewController *viewControllerToReturnTo = [navigationSetup.navigationController viewControllerForNavigationSetup:navigationSetup];
    if (viewControllerToReturnTo == navigationSetup.navigationController.topViewController) return nil;

    if ([navigationSetup.breadcrumbs count] > 0) {
        return [[RLDBreadcrumbNavigationCommand alloc] initWithNavigationSetup:navigationSetup];
    } else {
        return [[RLDDirectNavigationCommand alloc] initWithNavigationSetup:navigationSetup];
    }
}

#pragma mark - Suitability checking

+ (BOOL)canHandleNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    return (navigationSetup.origin && navigationSetup.destination);
}

+ (NSArray *)origins {
    return nil;
}

+ (Class)destination {
    return nil;
}

#pragma mark - Designated initializer

- (instancetype)initWithNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    if (![self.class canHandleNavigationSetup:navigationSetup]) return nil;
        
    if (self = [super init]) {
        _navigationSetup = navigationSetup;
    }
    return self;
}

#pragma mark - Navigation

- (void)execute {
    // Default implementation does nothing
}

@end