#import "RLDFolderViewController.h"

#import "RLDNavigation.h"

@implementation RLDFolderViewController

- (IBAction)chatWithFirstUserTapped {
    [self navigateToProfileWithUserId:@"1"];
}

- (IBAction)chatWithSecondUserTapped {
    [self navigateToProfileWithUserId:@"2"];
}

- (void)navigateToProfileWithUserId:(NSString *)userId {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDProfileViewController")
                                   properties: @{@"userId" : userId}
                         navigationController:self.navigationController] go];
}

@end
