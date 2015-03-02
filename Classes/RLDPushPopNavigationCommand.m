#import "RLDPushPopNavigationCommand.h"

#import "RLDNavigationSetup.h"
#import "UINavigationController+RLDNavigationSetup.h"

#import "NSObject+PropertyChecking.h"

static NSString *const defaultnibName = @"Main";

@implementation RLDPushPopNavigationCommand

#pragma mark - Idoneity checking

+ (BOOL)canHandleNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    BOOL isDestinationValid = ([navigationSetup.destination isSubclassOfClass:self.destination]);
    if (!isDestinationValid) return NO;
    
    BOOL canPushToDestination = [self isOriginClassValid:navigationSetup.origin];
    
    BOOL canPopToDestinationInNavigationSetup = ([navigationSetup.navigationController viewControllerForNavigationSetup:navigationSetup] != nil);
    
    return (canPopToDestinationInNavigationSetup || canPushToDestination);
}

+ (BOOL)isOriginClassValid:(Class)class {
    if ([self.origins count] == 0) return YES;
    
    BOOL classIsValid = NO;
    for (Class originClass in self.origins) {
        if ([class isSubclassOfClass:originClass]) {
            classIsValid = YES;
            break;
        }
    }
    
    return classIsValid;
}

+ (NSString *)viewControllerStoryboardIdentifier {
    return nil;
}

+ (NSString *)nibName {
    return defaultnibName;
}

#pragma mark - Animation configuration

+ (BOOL)animatesTransitions {
    return YES;
}

#pragma mark - Execution

- (void)execute {
    UIViewController *viewControllerToReturnTo = [self.navigationSetup.navigationController viewControllerForNavigationSetup:self.navigationSetup];
    if (viewControllerToReturnTo) {
        [self popToViewController:viewControllerToReturnTo];
    } else {
        [self pushNewViewController];
    }
}

- (void)popToViewController:(UIViewController *)viewControllerToReturnTo {
    [self.navigationSetup.navigationController popToViewController:viewControllerToReturnTo animated:[self.class animatesTransitions]];
}

- (void)pushNewViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:self.class.nibName bundle:nil];
    UIViewController *viewControllerToPresent = [storyBoard instantiateViewControllerWithIdentifier:[self.class viewControllerStoryboardIdentifier]];
    [self configureViewController:viewControllerToPresent];
    
    [self.navigationSetup.navigationController pushViewController:viewControllerToPresent animated:[self.class animatesTransitions]];
}

#pragma mark - Destination view controller configuration

- (void)configureViewController:(UIViewController *)viewController {
    [viewController loadView];
    
    [[(RLDNavigationSetup *)self.navigationSetup properties] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([viewController canSetProperty:key]) {
            [viewController setValue:value forKey:key];
        }
    }];
}

@end