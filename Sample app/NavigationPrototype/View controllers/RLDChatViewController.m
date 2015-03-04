#import "RLDChatViewController.h"

#import "RLDNavigation.h"

@interface RLDChatViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RLDChatViewController

- (void)setUserId:(NSString *)userId {
    _userId = [userId copy];
    
    self.titleLabel.text = [NSString stringWithFormat:@"Chat with user %@", userId];
}

- (IBAction)jumpToProfileTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDProfileViewController")
                                   properties: @{@"userId" : self.userId}
                         navigationController:self.navigationController] go];
}

- (IBAction)jumpToProfileForSecondUserTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDProfileViewController")
                                   properties: @{@"userId" : @"2"}
                                  breadcrumbs:@[NSClassFromString(@"RLDChatViewController")]
                         navigationController:self.navigationController] go];
}

- (IBAction)jumpToChatWithSecondUserTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDChatViewController")
                                   properties: @{@"userId" : @"2"}
                                  breadcrumbs:@[NSClassFromString(@"RLDConnectionsViewController")]
                         navigationController:self.navigationController] go];
}

@end
