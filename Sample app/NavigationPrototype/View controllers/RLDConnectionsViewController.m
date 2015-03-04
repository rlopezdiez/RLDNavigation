#import "RLDConnectionsViewController.h"

#import "RLDNavigation.h"

@implementation RLDConnectionsViewController

- (IBAction)chatWithFirstUserTapped {
    [self navigateToChatWithUserId:@"1"];
}

- (IBAction)chatWithSecondUserTapped {
    [self navigateToChatWithUserId:@"2"];
}

- (void)navigateToChatWithUserId:(NSString *)userId {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDChatViewController")
                                   properties: @{@"userId" : userId}
                         navigationController:self.navigationController] go];
}

@end
