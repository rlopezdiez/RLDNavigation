#import "RLDBreadcrumbNavigationCommand.h"

#import "RLDNavigationSetup.h"
#import "RLDNavigationSetup+RLDNavigationCommand.h"

@implementation RLDBreadcrumbNavigationCommand

- (void)execute {
    NSMutableArray *milestones = [NSMutableArray arrayWithArray:self.navigationSetup.breadcrumbs];
    [milestones addObject:self.navigationSetup.destination];
    
    for (Class destination in milestones) {
        [[RLDNavigationSetup setupWithDestination:destination
                                       properties:self.navigationSetup.properties
                                      breadcrumbs:nil
                             navigationController:self.navigationSetup.navigationController] go];
    }
}

@end
