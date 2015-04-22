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
    [self goToDestination:NSClassFromString(@"RLDChatViewController")
               properties: @{@"userId" : self.userId}];
}

- (IBAction)jumpToConnectionsTapped {
    [self goToDestination:NSClassFromString(@"RLDConnectionsViewController")];
}

- (IBAction)jumpToMenuTapped {
    [self goToDestination:NSClassFromString(@"RLDMenuViewController")];
}

- (IBAction)jumpToProfileForSecondUserTapped {
    [self goToDestination:NSClassFromString(@"RLDProfileViewController")
               properties: @{@"userId" : @"2"}];
}

- (IBAction)jumpToChatWithSecondUserTapped {
    [self goToDestination:NSClassFromString(@"RLDChatViewController")
               properties: @{@"userId" : @"2"}
              breadcrumbs:@[NSClassFromString(@"RLDProfileViewController")]];
}

@end
