#import "RLDProfileViewController.h"

#import "RLDNavigation.h"

@interface RLDProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RLDProfileViewController

- (void)setUserId:(NSString *)userId {
    _userId = [userId copy];
    
    self.titleLabel.text = [NSString stringWithFormat:@"Profile of user %@", userId];
}

- (IBAction)chatWithUserTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDChatViewController")
                                   properties: @{@"userId" : self.userId}
                         navigationController:self.navigationController] go];
}

- (IBAction)jumpToConnectionsTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDConnectionsViewController")
                         navigationController:self.navigationController] go];
}

- (IBAction)jumpToMenuTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDMenuViewController")
                         navigationController:self.navigationController] go];
}

- (IBAction)jumpToProfileForSecondUserTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDProfileViewController")
                                   properties: @{@"userId" : @"2"}
                         navigationController:self.navigationController] go];
}

- (IBAction)jumpToChatWithSecondUserTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDChatViewController")
                                   properties: @{@"userId" : @"2"}
                                  breadcrumbs:@[NSClassFromString(@"RLDProfileViewController")]
                         navigationController:self.navigationController] go];
}

@end
