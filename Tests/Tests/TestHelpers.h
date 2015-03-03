#import "RLDPushPopNavigationCommand.h"

#import <UIKit/UIKit.h>

@interface NSObject (TestingHelpers)

+ (Class)registerSubclassWithName:(NSString *)name;

@end

@interface RLDPushPopNavigationCommand (TestingHelpers)

+ (Class)registerSubclassWithName:(NSString *)name origins:(NSArray *)origins destination:(Class)destination;
+ (void)unregisterAllSubclasses;

@end

@interface UINavigationController (TestingHelpers)

- (void)setRootViewControllerWithClass:(Class)class;
- (BOOL)hasClassChain:(NSArray *)classChain;

@end
