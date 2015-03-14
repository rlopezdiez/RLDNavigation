#import "RLDBreadcrumbNavigationCommand.h"

#import "RLDNavigationSetup.h"
#import "RLDNavigationSetup+RLDNavigationCommand.h"

@implementation RLDBreadcrumbNavigationCommand

- (void)execute {
    NSMutableArray *milestones = [NSMutableArray arrayWithArray:self.navigationSetup.breadcrumbs];
    [milestones addObject:self.navigationSetup.destination];
    
    NSMutableArray *navigationCommands = [NSMutableArray arrayWithCapacity:[milestones count]];
    
    Class origin = self.navigationSetup.navigationController.topViewController.class;
    for (Class destination in milestones) {
        RLDNavigationSetup *navigationSetup = [[RLDNavigationSetup alloc] initWithOrigin:origin
                                                                             destination:destination
                                                                              properties:self.navigationSetup.properties
                                                                             breadcrumbs:nil
                                                                    navigationController:self.navigationSetup.navigationController];
        
        id<RLDNavigationCommand> navigationCommand = [RLDNavigationCommand navigationCommandWithNavigationSetup:navigationSetup];
        
        if (navigationCommand) {
            [[navigationCommands lastObject] setCompletionBlock:^{
                [navigationCommand execute];
            }];
            
            [navigationCommands addObject:navigationCommand];
        }
        
        origin = destination;
    }
    
    [[navigationCommands lastObject] setCompletionBlock:self.completionBlock];
    
    [[navigationCommands firstObject] execute];
}

@end
