#import "RLDDirectNavigationCommand.h"

@interface RLDPushPopNavigationCommand : RLDDirectNavigationCommand

+ (NSString *)viewControllerStoryboardIdentifier;
+ (NSString *)nibName; // Defaults to @"Main"

+ (BOOL)animatesTransitions; // Defaults to YES

@end