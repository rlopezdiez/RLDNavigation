#import "RLDNavigationSetup+RLDNavigationCommand.h"

#import "RLDNavigationCommand.h"

@implementation RLDNavigationSetup (RLDNavigationCommand)

- (void)go {
    [self goWithCompletionBlock:NULL];
}

- (void)goWithCompletionBlock:(void(^)(void))completionBlock {
    [[RLDNavigationCommand navigationCommandWithNavigationSetup:self
                                                completionBlock:completionBlock] execute];
}

@end