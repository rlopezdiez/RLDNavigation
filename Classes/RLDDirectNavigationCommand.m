#import "RLDDirectNavigationCommand.h"
#import "RLDNavigationCommand+NavigationCommandRegister.h"
#import "RLDDirectNavigationCommand+PathSearching.h"

#import "RLDNavigationSetup.h"

@interface RLDDirectNavigationCommand ()

@property (nonatomic, strong) NSArray *navigationCommandClassChain;

@end

@implementation RLDDirectNavigationCommand

#pragma mark - Execution

- (void)execute {
    if ([[[self class] availableCommandClasses] count] == 0) {
        [[self class] registerClassesConformingToNavigationCommandProtocol];
    }
    
    NSMutableArray *navigationCommands = [NSMutableArray arrayWithCapacity:[self.navigationCommandClassChain count]];
    
    RLDNavigationSetup *navigationSetup = [self.navigationSetup copy];
    
    for (Class navigationCommandClass in self.navigationCommandClassChain) {
        navigationSetup.destination = [navigationCommandClass destination];
        
        id<RLDNavigationCommand> navigationCommand = [[navigationCommandClass alloc] init];
        if (navigationCommand) {
            [navigationCommand setNavigationSetup:[navigationSetup copy]];
            
            [[navigationCommands lastObject] setCompletionBlock:^{
                [navigationCommand execute];
            }];
            
            [navigationCommands addObject:navigationCommand];
        }
        
        navigationSetup.origin = navigationSetup.destination;
    }
    
    [[navigationCommands lastObject] setCompletionBlock:self.completionBlock];
    
    [[navigationCommands firstObject] execute];
}

#pragma mark - Navigation command class chain lazy instantation and path searching

- (NSArray *)navigationCommandClassChain {
    if (!_navigationCommandClassChain) {
        _navigationCommandClassChain = [self navigationCommandClassChainInClasses:[[self class] availableCommandClasses]
                                                              withNavigationSetup:self.navigationSetup];
    }
    return _navigationCommandClassChain;
}

@end
