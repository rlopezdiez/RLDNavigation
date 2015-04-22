#import <UIKit/UIKit.h>

@interface UIView (RLDNavigationHelper)

- (void)goToDestination:(Class)destination;

- (void)goToDestination:(Class)destination
            breadcrumbs:(NSArray *)breadcrumbs;

- (void)goToDestination:(Class)destination
             properties:(NSDictionary *)properties;

- (void)goToDestination:(Class)destination
             properties:(NSDictionary *)properties
            breadcrumbs:(NSArray *)breadcrumbs;

- (void)goToDestination:(Class)destination
        completionBlock:(void(^)(void))completionBlock;

- (void)goToDestination:(Class)destination
            breadcrumbs:(NSArray *)breadcrumbs
        completionBlock:(void(^)(void))completionBlock;

- (void)goToDestination:(Class)destination
             properties:(NSDictionary *)properties
        completionBlock:(void(^)(void))completionBlock;

- (void)goToDestination:(Class)destination
             properties:(NSDictionary *)properties
            breadcrumbs:(NSArray *)breadcrumbs
        completionBlock:(void(^)(void))completionBlock;

@end