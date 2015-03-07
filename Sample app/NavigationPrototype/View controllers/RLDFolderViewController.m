#import "RLDFolderViewController.h"

#import "RLDNavigation.h"

@implementation RLDFolderViewController

- (IBAction)profileOfFirstUserTapped {
    [self navigateToProfileWithUserId:@"1"];
}

- (IBAction)profileOfSecondUserTapped {
    [self navigateToProfileWithUserId:@"2"];
}

- (void)navigateToProfileWithUserId:(NSString *)userId {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDProfileViewController")
                                   properties: @{@"userId" : userId}
                         navigationController:self.navigationController] go];
}

@end
