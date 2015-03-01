#import "RLDDirectNavigationCommand.h"

@interface RLDDirectNavigationCommand (NavigationCommandRegister)

+ (void)registerClassesConformingToNavigationCommandProtocol;

@property (readonly) NSSet *availableCommandClasses;

@end