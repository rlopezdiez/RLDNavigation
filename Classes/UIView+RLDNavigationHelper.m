#import "UIViewController+RLDNavigationHelper.h"

#import "RLDNavigationSetup.h"
#import "RLDNavigationSetup+RLDNavigationCommand.h"

@implementation UIView (RLDNavigationHelper)

- (void)goToDestination:(Class)destination {
    [self goToDestination:destination
               properties:nil
              breadcrumbs:nil
          completionBlock:NULL];
}

- (void)goToDestination:(Class)destination
            breadcrumbs:(NSArray *)breadcrumbs {
    [self goToDestination:destination
               properties:nil
              breadcrumbs:breadcrumbs
          completionBlock:NULL];
}

- (void)goToDestination:(Class)destination
             properties:(NSDictionary *)properties {
    [self goToDestination:destination
               properties:properties
              breadcrumbs:nil
          completionBlock:NULL];
}

- (void)goToDestination:(Class)destination
             properties:(NSDictionary *)properties
            breadcrumbs:(NSArray *)breadcrumbs {
    [self goToDestination:destination
               properties:properties
              breadcrumbs:breadcrumbs
          completionBlock:NULL];
}

- (void)goToDestination:(Class)destination
        completionBlock:(void(^)(void))completionBlock {
    [self goToDestination:destination
               properties:nil
              breadcrumbs:nil
          completionBlock:completionBlock];
}

- (void)goToDestination:(Class)destination
            breadcrumbs:(NSArray *)breadcrumbs
        completionBlock:(void(^)(void))completionBlock {
    [self goToDestination:destination
               properties:nil
              breadcrumbs:breadcrumbs
          completionBlock:completionBlock];
}

- (void)goToDestination:(Class)destination
             properties:(NSDictionary *)properties
        completionBlock:(void(^)(void))completionBlock {
    [self goToDestination:destination
               properties:properties
              breadcrumbs:nil
          completionBlock:completionBlock];
}

- (void)goToDestination:(Class)destination
             properties:(NSDictionary *)properties
            breadcrumbs:(NSArray *)breadcrumbs
        completionBlock:(void(^)(void))completionBlock {
    UINavigationController *navigationController = [self topmostNavigationController];
    if (!navigationController) return;
    
    [[[RLDNavigationSetup alloc] initWithOrigin:[navigationController.topViewController class]
                                    destination:destination
                                     properties:properties
                                    breadcrumbs:breadcrumbs
                           navigationController:navigationController]
     goWithCompletionBlock:completionBlock];
}

- (UINavigationController *)topmostNavigationController {
    for (UIView *nextView = [self superview]; nextView != nil; nextView = nextView.superview) {
        UIResponder *nextResponder = [nextView nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)nextResponder;
        }
    }
    return nil;
}

@end