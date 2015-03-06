#import "RLDProfileNavigationCommand.h"

#import <UIKit/UIKit.h>
#import "RLDNavigationSetup.h"
#import "RLDChatViewController.h"
#import "RLDNavigationCommand+NavigationCommandRegister.h"

static NSString *const originClassNameChat = @"RLDChatViewController";
static NSString *const originClassNameFolder = @"RLDFolderViewController";
static NSString *const destinationClassName = @"RLDProfileViewController";

@implementation RLDProfileNavigationCommand

#pragma mark - Navigation command registering

+ (void)load {
    [self registerCommandClass];
}

#pragma mark - Suitability checking

+ (BOOL)canHandleNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    BOOL canHandleNavigationSetup = [super canHandleNavigationSetup:navigationSetup];
    
    if (canHandleNavigationSetup) {
        UIViewController * topViewController = navigationSetup.navigationController.topViewController;
        if (topViewController.class == [RLDChatViewController class]) {
            NSString *userId = navigationSetup.properties[@"userId"] ? navigationSetup.properties[@"userId"] : nil;
            canHandleNavigationSetup = [[(RLDChatViewController *)topViewController userId] isEqualToString:userId];
        }
    }
    
    return canHandleNavigationSetup;
}

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
