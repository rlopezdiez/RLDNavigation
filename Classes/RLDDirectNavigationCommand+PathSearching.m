#import "RLDDirectNavigationCommand+PathSearching.h"

#import "RLDNavigationSetup.h"

@implementation RLDDirectNavigationCommand (PathSearching)

- (NSArray *)navigationCommandClassChainInClasses:(id<NSFastEnumeration>)availableCommandsClasses
                              withNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    NSMutableArray *originNavigationCommandClasses = [self navigationCommandClassesInClasses:availableCommandsClasses
                                                                                  withOrigin:navigationSetup.origin
                                                                                 destination:nil];
    NSMutableArray *directNavigationCommandClasses = [self navigationCommandClassesInClasses:originNavigationCommandClasses
                                                                                  withOrigin:navigationSetup.origin
                                                                                 destination:navigationSetup.destination];
    if ([directNavigationCommandClasses count]) {
        return @[[directNavigationCommandClasses firstObject]];
    }
    
    NSMapTable *linksBetweenNavigationCommands = [NSMapTable weakToWeakObjectsMapTable];
    
    NSMutableArray *nextNavigationCommandClasses = [originNavigationCommandClasses mutableCopy];
    
    __block Class lastNavigationCommandClassInChain = nil;
    while (nextNavigationCommandClasses.count) {
        
        Class parentClass = [nextNavigationCommandClasses firstObject];
        [nextNavigationCommandClasses removeObject:parentClass];
        
        [self enumerateNavigationCommandClasses:availableCommandsClasses
                                     withOrigin:parentClass.destination
                                    destination:nil
                                     usingBlock:^(Class navigationCommandClass, BOOL *stop) {
                                         [linksBetweenNavigationCommands setObject:parentClass forKey:navigationCommandClass];
                                         if ([navigationCommandClass destination] == navigationSetup.destination) {
                                             lastNavigationCommandClassInChain = navigationCommandClass;
                                             *stop = YES;
                                         } else {
                                             [nextNavigationCommandClasses addObject:navigationCommandClass];
                                         }
                                     }];
        
        if (lastNavigationCommandClassInChain) {
            return [self navigationCommandClassChainWithOrigins:originNavigationCommandClasses
                                 linksBetweenNavigationCommands:linksBetweenNavigationCommands
                                     lastNavigationCommandClass:lastNavigationCommandClassInChain];
        }
    }
    
    return nil;
}

- (NSMutableArray *)navigationCommandClassesInClasses:(id<NSFastEnumeration>)classes withOrigin:(Class)origin destination:(Class)destination {
    NSMutableArray *navigationCommandClasses = [NSMutableArray array];
    
    [self enumerateNavigationCommandClasses:classes
                                 withOrigin:origin
                                destination:destination
                                 usingBlock:^(Class navigationCommandClass, BOOL *stop) {
                                     [navigationCommandClasses addObject:navigationCommandClass];
                                 }];
    
    return navigationCommandClasses;
}

- (void)enumerateNavigationCommandClasses:(id<NSFastEnumeration>)navigationCommandClasses
                               withOrigin:(Class)origin
                              destination:(Class)destination
                               usingBlock:(void (^)(Class navigationCommandClass, BOOL *stop))block {
    
    NSParameterAssert(block);
    RLDNavigationSetup *navigationSetup = [[RLDNavigationSetup alloc] initWithOrigin:origin
                                                                         destination:destination
                                                                          properties:self.navigationSetup.properties
                                                                         breadcrumbs:nil
                                                                navigationController:self.navigationSetup.navigationController];
    
    BOOL shouldStop = NO;
    for (Class navigationCommandClass in navigationCommandClasses) {
        if (!destination) {
            navigationSetup.destination = [navigationCommandClass destination];
        }
        if (([navigationCommandClass canHandleNavigationSetup:navigationSetup]) && ([navigationCommandClass destination])) {
            block(navigationCommandClass, &shouldStop);
        }
        if (shouldStop) break;
    }
    
}

- (NSArray *)navigationCommandClassChainWithOrigins:(NSArray *)originNavigationCommandClasses
                     linksBetweenNavigationCommands:(NSMapTable *)linksBetweenNavigationCommands
                         lastNavigationCommandClass:(Class)lastNavigationCommandClass {
    
    NSMutableArray *navigationCommandClassChain = [NSMutableArray array];
    
    Class class = lastNavigationCommandClass;
    do {
        [navigationCommandClassChain insertObject:class atIndex:0];
        if ([originNavigationCommandClasses containsObject:class]) break;
        class = [linksBetweenNavigationCommands objectForKey:class];
    } while (class);

    return [navigationCommandClassChain copy];
}

@end