#import "RLDNavigationSetup.h"

@interface RLDNavigationSetup (RLDNavigationCommand)

- (void)go;
- (void)goWithCompletionBlock:(void(^)(void))completionBlock;

@end