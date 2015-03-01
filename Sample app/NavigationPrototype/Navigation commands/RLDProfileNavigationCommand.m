#import "RLDProfileNavigationCommand.h"

static NSString *const originClassNameChat = @"RLDChatViewController";
static NSString *const originClassNameFolder = @"RLDFolderViewController";
static NSString *const destinationClassName = @"RLDProfileViewController";

@implementation RLDProfileNavigationCommand

#pragma mark - Idoneity checking

+ (NSArray *)origins {
    return @[NSClassFromString(originClassNameChat),
             NSClassFromString(originClassNameFolder)];
}

+ (Class)destination {
    return NSClassFromString(self.viewControllerStoryboardIdentifier);
}

+ (NSString *)viewControllerStoryboardIdentifier {
    return destinationClassName;
}

@end
