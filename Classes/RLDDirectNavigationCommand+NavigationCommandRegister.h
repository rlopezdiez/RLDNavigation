#import "RLDDirectNavigationCommand.h"

@interface RLDDirectNavigationCommand (NavigationCommandRegister)

+ (void)registerClassesConformingToNavigationCommandProtocol;
+ (void)registerCommandClass;
+ (NSSet *)availableCommandClasses;

@end