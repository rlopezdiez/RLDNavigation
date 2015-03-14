#import "RLDNavigationCommand.h"

#import "RLDNavigationSetup.h"

#import "RLDBreadcrumbNavigationCommand.h"
#import "RLDDirectNavigationCommand.h"
#import "UINavigationController+RLDNavigationSetup.h"

@implementation RLDNavigationCommand

@synthesize
navigationSetup = _navigationSetup,
completionBlock = _completionBlock;

#pragma mark - Factory methods

+ (instancetype)navigationCommandWithNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    return [self navigationCommandWithNavigationSetup:navigationSetup completionBlock:NULL];
}

+ (instancetype)navigationCommandWithNavigationSetup:(RLDNavigationSetup *)navigationSetup completionBlock:(void(^)(void))completionBlock {
    // We check if we are already at the destination
    UIViewController *viewControllerToReturnTo = [navigationSetup.navigationController viewControllerForNavigationSetup:navigationSetup];
    if (viewControllerToReturnTo == navigationSetup.navigationController.topViewController) return nil;

    if ([navigationSetup.breadcrumbs count] > 0) {
        return [[RLDBreadcrumbNavigationCommand alloc] initWithNavigationSetup:navigationSetup completionBlock:completionBlock];
    } else {
        return [[RLDDirectNavigationCommand alloc] initWithNavigationSetup:navigationSetup completionBlock:completionBlock];
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

- (instancetype)initWithNavigationSetup:(RLDNavigationSetup *)navigationSetup completionBlock:(void(^)(void))completionBlock {
    if (![self.class canHandleNavigationSetup:navigationSetup]) return nil;
    
    if (self = [super init]) {
        _navigationSetup = navigationSetup;
        _completionBlock = completionBlock;
    }
    return self;
}

#pragma mark - Navigation

- (void)execute {
    if (self.completionBlock) {
        self.completionBlock();
    }
}

@end