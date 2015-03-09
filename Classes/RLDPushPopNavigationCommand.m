#import "RLDPushPopNavigationCommand.h"

#import "RLDNavigationSetup.h"
#import "UINavigationController+RLDNavigationSetup.h"

#import "NSObject+PropertyChecking.h"

static NSString *const defaultnibName = @"Main";

@implementation RLDPushPopNavigationCommand

#pragma mark - Suitability checking

+ (BOOL)canHandleNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    BOOL isDestinationValid = ([navigationSetup.destination isSubclassOfClass:self.destination]);
    if (!isDestinationValid) return NO;
    
    BOOL canPopToDestinationInNavigationSetup = ([navigationSetup.navigationController viewControllerForNavigationSetup:navigationSetup] != nil);
    BOOL canPushToDestination = canPopToDestinationInNavigationSetup ?: [self isOriginClassValid:navigationSetup.origin];
   
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
    if (self.navigationSetup.navigationController.topViewController != viewControllerToReturnTo) {
        [self.navigationSetup.navigationController popToViewController:viewControllerToReturnTo animated:[self.class animatesTransitions]];
    }
}

- (void)pushNewViewController {
    UIViewController *viewControllerToPresent;
    if ([self.class nibName] && [self.class viewControllerStoryboardIdentifier]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[self.class nibName] bundle:nil];
        viewControllerToPresent = [storyBoard instantiateViewControllerWithIdentifier:[self.class viewControllerStoryboardIdentifier]];
    } else {
        viewControllerToPresent = [[[self.class destination] alloc] init];
    }
    [self configureViewController:viewControllerToPresent];
    
    [self.navigationSetup.navigationController pushViewController:viewControllerToPresent animated:[self.class animatesTransitions]];
}

#pragma mark - Destination view controller configuration

- (void)configureViewController:(UIViewController *)viewController {
    [viewController loadView];
    [viewController setProperties:self.navigationSetup.properties];
}

@end