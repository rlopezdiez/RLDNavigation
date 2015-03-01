#import "RLDNavigationSetup+RLDNavigationCommand.h"

#import "RLDNavigationCommand.h"

@implementation RLDNavigationSetup (RLDNavigationCommand)

- (void)go {
    [[RLDNavigationCommand navigationCommandWithNavigationSetup:self] execute];
}

@end