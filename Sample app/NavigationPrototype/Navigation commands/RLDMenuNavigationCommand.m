#import "RLDMenuNavigationCommand.h"
#import "RLDNavigationCommand+NavigationCommandRegister.h"

static NSString *const destinationClassName = @"RLDMenuViewController";

@implementation RLDMenuNavigationCommand

#pragma mark - Navigation command registering

+ (void)load {
    [self registerCommandClass];
}

#pragma mark - Suitability checking

+ (Class)destination {
    return NSClassFromString(destinationClassName);
}

+ (NSString *)viewControllerStoryboardIdentifier {
    return destinationClassName;
}

@end
