#import "RLDConnectionsNavigationCommand.h"

static NSString *const originClassName = @"RLDMenuViewController";
static NSString *const destinationClassName = @"RLDConnectionsViewController";

@implementation RLDConnectionsNavigationCommand

#pragma mark - Idoneity checking

+ (NSArray *)origins {
    return @[NSClassFromString(originClassName)];
}

+ (Class)destination {
    return NSClassFromString(destinationClassName);
}

+ (NSString *)viewControllerStoryboardIdentifier {
    return destinationClassName;
}

@end
