#import "RLDFolderNavigationCommand.h"

static NSString *const originClassName = @"RLDMenuViewController";
static NSString *const destinationClassName = @"RLDFolderViewController";

@implementation RLDFolderNavigationCommand

#pragma mark - Suitability checking

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
