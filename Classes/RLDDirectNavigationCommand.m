#import "RLDDirectNavigationCommand.h"
#import "RLDDirectNavigationCommand+NavigationCommandRegister.h"
#import "RLDDirectNavigationCommand+PathSearching.h"

#import "RLDNavigationSetup.h"

@interface RLDNavigationCommand (ProtectedInitializer)

- (instancetype)initWithNavigationSetup:(RLDNavigationSetup *)navigationSetup;

@end

@interface RLDDirectNavigationCommand ()

@property (nonatomic, strong) NSArray *navigationCommandClassChain;

@end

@implementation RLDDirectNavigationCommand

#pragma mark - Navigation command registering

+ (void)initialize {
    if (self != [RLDDirectNavigationCommand class]) return;
    
    [self registerClassesConformingToNavigationCommandProtocol];
}

#pragma mark - Execution

- (void)execute {
    RLDNavigationSetup *navigationSetup = [self.navigationSetup copy];
    
    for (Class navigationCommandClass in self.navigationCommandClassChain) {
        navigationSetup.destination = [navigationCommandClass destination];
        
        id<RLDNavigationCommand> navigationCommand = [[navigationCommandClass alloc] initWithNavigationSetup:[navigationSetup copy]];
        [self synchronousExecutionOfAnimationBlock:^{
            [navigationCommand execute];
        }];
        
        navigationSetup.origin = navigationSetup.destination;
    }
}

- (void)synchronousExecutionOfAnimationBlock:(void (^)())animationBlock {
    __block BOOL finished = NO;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        finished = YES;
    }];
    
    animationBlock();
    
    [CATransaction commit];
    
    while (!finished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }
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
