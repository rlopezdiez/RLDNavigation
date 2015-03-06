#import "RLDFolderNavigationCommand.h"
#import "RLDDirectNavigationCommand+NavigationCommandRegister.h"

static NSString *const originClassName = @"RLDMenuViewController";
static NSString *const destinationClassName = @"RLDFolderViewController";

@implementation RLDFolderNavigationCommand

#pragma mark - Navigation command registering

+ (void)load {
    [self registerCommandClass];
}

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
