#import "RLDMenuNavigationCommand.h"

static NSString *const destinationClassName = @"RLDMenuViewController";

@implementation RLDMenuNavigationCommand

#pragma mark - Suitability checking

+ (Class)destination {
    return NSClassFromString(destinationClassName);
}

+ (NSString *)viewControllerStoryboardIdentifier {
    return destinationClassName;
}

@end
