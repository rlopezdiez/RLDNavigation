#import "RLDMenuViewController.h"

#import "RLDNavigation.h"
#import "RLDContactCardViewModel.h"

@implementation RLDMenuViewController

- (IBAction)peopleNearbyTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDFolderViewController")
                         navigationController:self.navigationController] go];
}

- (IBAction)connectionsTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDConnectionsViewController")
                         navigationController:self.navigationController] go];
}

- (IBAction)chatTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDChatViewController")
                                   properties:@{@"userId" : @"#1"}
                         navigationController:self.navigationController] go];
}

- (IBAction)profileTapped {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDProfileViewController")
                                   properties:@{@"userId" : @"#2"}
                         navigationController:self.navigationController] go];
}

- (IBAction)chatFromProfileTapped:(id)sender {
    [[RLDNavigationSetup setupWithDestination:NSClassFromString(@"RLDChatViewController")
                                   properties:@{@"userId" : @"#1"}
                                  breadcrumbs: @[NSClassFromString(@"RLDProfileViewController")]
                         navigationController:self.navigationController] go];
}

- (IBAction)contactCardTapped {
    RLDContactCardViewModel *viewModel = [RLDContactCardViewModel viewModelWithName:@"John"
                                                                            surname:@"Doe"
                                                                              email:@"john.doe@example.com"];
    [[RLDNavigationSetup setupWithViewModel:viewModel
                       navigationController:self.navigationController] go];
}

@end
