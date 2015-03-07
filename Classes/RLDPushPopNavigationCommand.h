#import "RLDDirectNavigationCommand.h"

@interface RLDPushPopNavigationCommand : RLDDirectNavigationCommand

+ (NSString *)viewControllerStoryboardIdentifier; // Optional
+ (NSString *)nibName; // Defaults to @"Main"

+ (BOOL)animatesTransitions; // Defaults to YES

@end