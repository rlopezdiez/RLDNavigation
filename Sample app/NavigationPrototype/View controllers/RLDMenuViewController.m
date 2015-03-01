#import "RLDMenuViewController.h"

#import "RLDNavigation.h"

@implementation RLDMenuViewController

- (IBAction)peopleNearbyTapped {
    [self navigateTo:@"RLDFolderViewController"];
}

- (IBAction)connectionsTapped {
    [self navigateTo:@"RLDConnectionsViewController"];
}

- (IBAction)chatTapped {
    [self navigateTo:@"RLDChatViewController" userId:@"#1"];
}

- (IBAction)profileTapped {
    [self navigateTo:@"RLDProfileViewController" userId:@"#2"];
}

- (IBAction)chatFromProfileTapped:(id)sender {
    [self navigateTo:@"RLDChatViewController" userId:@"#1" passingBy:@"RLDProfileViewController"];
}

#pragma mark - Helper methods for navigation

- (void)navigateTo:(NSString *)string {
    [self navigateTo:string userId:nil passingBy:nil];
}

- (void)navigateTo:(NSString *)string userId:(NSString *)userId {
    [self navigateTo:string userId:userId passingBy:nil];
}

- (void)navigateTo:(NSString *)destinationClassName
            userId:(NSString *)userId
         passingBy:(NSString *)passingBy {
    NSDictionary *properties = (userId ? @{@"userId" : userId} : nil);
    NSArray *breadcrumbs = (passingBy ? @[NSClassFromString(passingBy)] : nil);

    [[RLDNavigationSetup setupWithDestination:NSClassFromString(destinationClassName)
                                   properties:properties
                                  breadcrumbs:breadcrumbs
                         navigationController:self.navigationController] go];
}

@end
