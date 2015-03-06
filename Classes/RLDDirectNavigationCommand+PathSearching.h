#import "RLDDirectNavigationCommand.h"

@interface RLDDirectNavigationCommand (PathSearching)

- (NSArray *)navigationCommandClassChainInClasses:(id<NSFastEnumeration>)availableCommandsClasses
                              withNavigationSetup:(RLDNavigationSetup *)navigationSetup;

@end