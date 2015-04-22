#import "RLDMenuViewController.h"

#import "RLDNavigation.h"
#import "RLDContactCardViewModel.h"
#import "RLDNavigationSetup+URLs.h"

@implementation RLDMenuViewController

- (IBAction)peopleNearbyTapped {
    [self goToDestination:NSClassFromString(@"RLDFolderViewController")];
}

- (IBAction)connectionsTapped {
    [self goToDestination:NSClassFromString(@"RLDConnectionsViewController")];
}

- (IBAction)chatTapped {
    [self goToDestination:NSClassFromString(@"RLDChatViewController")
               properties:@{@"userId" : @"1"}];
}

- (IBAction)chatFromProfileTapped {
    [self goToDestination:NSClassFromString(@"RLDChatViewController")
               properties:@{@"userId" : @"1"}
              breadcrumbs: @[NSClassFromString(@"RLDProfileViewController")]];
}

- (IBAction)profileTapped {
    [[RLDNavigationSetup setupWithUrl:@"folder/profile?userId=2"
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
