#import "RLDNavigationCommand.h"

@interface RLDNavigationCommand (NavigationCommandRegister)

+ (void)registerClassesConformingToNavigationCommandProtocol;
+ (void)registerCommandClass;
+ (NSSet *)availableCommandClasses;

@end