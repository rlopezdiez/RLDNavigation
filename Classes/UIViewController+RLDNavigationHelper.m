#import "UIViewController+RLDNavigationHelper.h"

#import "RLDNavigationSetup.h"
#import "RLDNavigationSetup+RLDNavigationCommand.h"

@implementation UIViewController (RLDNavigationHelper)

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
    [[[RLDNavigationSetup alloc] initWithOrigin:[self class]
                                    destination:destination
                                     properties:properties
                                    breadcrumbs:breadcrumbs
                           navigationController:self.navigationController]
     goWithCompletionBlock:completionBlock];
}

@end