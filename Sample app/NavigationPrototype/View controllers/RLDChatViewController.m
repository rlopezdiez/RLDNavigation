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
    [self goToDestination:NSClassFromString(@"RLDProfileViewController")
               properties: @{@"userId" : self.userId}];
}

- (IBAction)jumpToProfileForSecondUserTapped {
    [self goToDestination:NSClassFromString(@"RLDProfileViewController")
               properties: @{@"userId" : @"2"}
              breadcrumbs:@[NSClassFromString(@"RLDChatViewController")]];
}

- (IBAction)jumpToChatWithSecondUserTapped {
    [self goToDestination:NSClassFromString(@"RLDChatViewController")
               properties: @{@"userId" : @"2"}
              breadcrumbs:@[NSClassFromString(@"RLDConnectionsViewController")]];
}

@end
