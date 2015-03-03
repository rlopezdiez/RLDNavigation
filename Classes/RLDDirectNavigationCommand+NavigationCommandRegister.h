#import "RLDDirectNavigationCommand.h"

@interface RLDDirectNavigationCommand (NavigationCommandRegister)

+ (void)registerClassesConformingToNavigationCommandProtocol;
+ (NSSet *)availableCommandClasses;

@end