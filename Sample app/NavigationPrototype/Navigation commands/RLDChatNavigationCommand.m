#import "RLDChatNavigationCommand.h"

static NSString *const originClassNameConnections = @"RLDConnectionsViewController";
static NSString *const originClassNameProfile = @"RLDProfileViewController";

static NSString *const destinationClassName = @"RLDChatViewController";
static NSString *const navigationSetupClassName = @"RLDNavigationSetup";

@implementation RLDChatNavigationCommand

#pragma mark - Idoneity checking

+ (NSArray *)origins {
    return @[NSClassFromString(originClassNameConnections),
             NSClassFromString(originClassNameProfile)];
}

+ (Class)destination {
    return NSClassFromString(self.viewControllerStoryboardIdentifier);
}

+ (NSString *)viewControllerStoryboardIdentifier {
    return destinationClassName;
}

@end
