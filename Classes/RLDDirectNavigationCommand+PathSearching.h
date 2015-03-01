#import "RLDNavigationCommand.h"

@interface RLDNavigationCommand (PathSearching)

- (NSArray *)navigationCommandClassChainInClasses:(id<NSFastEnumeration>)availableCommandsClasses
                              withNavigationSetup:(RLDNavigationSetup *)navigationSetup;

@end