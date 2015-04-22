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
    [self goToDestination:NSClassFromString(@"RLDChatViewController")
               properties: @{@"userId" : userId}];
}

@end
