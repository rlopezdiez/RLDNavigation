#import "TestHelpers.h"

#import <objc/runtime.h>

#import "RLDNavigationSetup.h"
#import "RLDNavigationCommand+NavigationCommandRegister.h"

@implementation NSRunLoop (Waiting)

+ (void)waitFor:(BOOL(^)(void))conditionBlock withTimeout:(NSTimeInterval)seconds {
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:seconds];
    
    while (!conditionBlock() && [[NSDate date] compare:timeout] == NSOrderedAscending) {
        [[self currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    }
}

@end

@implementation NSObject (TestingHelpers)

+ (Class)registerSubclassWithName:(NSString *)name {
    return [self registerSubclassWithName:name
                       readonlyProperties:nil
                      readwriteProperties:nil];
}

+ (Class)registerSubclassWithName:(NSString *)name
               readonlyProperties:(NSArray *)readonlyPropertyNames
              readwriteProperties:(NSArray *)readwritePropertyNames {
    Class newClass = objc_getClass([name UTF8String]);
    if (newClass) objc_disposeClassPair(newClass);
    
    newClass = objc_allocateClassPair(self, [name UTF8String], 0);
    
    for (NSString *readonlyPropertyName in readonlyPropertyNames) {
        [newClass addPropertyWithName:readonlyPropertyName readonly:YES];
    }
    
    for (NSString *readwritePropertyName in readwritePropertyNames) {
        [newClass addPropertyWithName:readwritePropertyName readonly:NO];
    }
    
    objc_registerClassPair(newClass);
    
    return newClass;
}

+ (void)addPropertyWithName:(NSString *)name readonly:(BOOL)isReadonly {
    const char *propertyName = [name UTF8String];
    
    class_addIvar(self, propertyName, sizeof(id), log2(sizeof(id)), @encode(id));
    
    objc_property_attribute_t type = {"T", "@"};
    objc_property_attribute_t retainOwnership = {"&", ""};
    objc_property_attribute_t ivar  = {"V", propertyName};
    objc_property_attribute_t readonly = {"R", ""};
    objc_property_attribute_t propertyAttributes[] = {type, retainOwnership, ivar, readonly};
    
    class_addProperty(self, propertyName, propertyAttributes, (isReadonly ? 4 : 3));
}

@end

@interface NSArray (ContentsComparison)

- (BOOL)compareContentsWith:(NSArray *)comparisonAray;

@end

@implementation NSArray (ContentsComparison)

- (BOOL)compareContentsWith:(NSArray *)comparisonAray {
    if ([comparisonAray count] != [self count]) return NO;
    
    __block BOOL hasSameContents = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj class] != comparisonAray[idx]) {
            hasSameContents = NO;
            *stop = YES;
        }
        
    }];
    return hasSameContents;
}

@end

static NSMutableArray *executedCommandClasses;

@implementation RLDTestingNavigationCommand

+ (void)load {
    executedCommandClasses = [NSMutableArray array];
}

+ (Class)registerSubclassWithName:(NSString *)name origins:(NSArray *)origins destination:(Class)destination {
    Class newClass = [self registerSubclassWithName:name];
    
    if (origins) [newClass setReturnObject:origins forSelector:@selector(origins)];
    if (destination) [newClass setReturnObject:destination forSelector:@selector(destination)];
    [newClass setReturnObject:nil forSelector:@selector(viewControllerStoryboardIdentifier)];
    
    [self setReturnBlock:(id)^(id self) {
        return NO;
    } forSelector:@selector(animatesTransitions)];

    [newClass configureCanHandleNavigationSetupMethod];
        
    [RLDDirectNavigationCommand registerClassesConformingToNavigationCommandProtocol];
    
    return newClass;
}

+ (void)setReturnObject:(id)returnObject forSelector:(SEL)selector {
    [self setReturnBlock:(id)^(id self) {
        return returnObject;
    } forSelector:selector];
}

+ (void)setReturnBlock:(id)block forSelector:(SEL)selector {
    // If we don't use the metaclass, class_addMethod will add an instance method
    Class metaClass = objc_getMetaClass([NSStringFromClass(self) UTF8String]);
    
    Method method = class_getClassMethod(metaClass, selector);
    const char *types = method_getTypeEncoding(method);
    IMP imp = imp_implementationWithBlock(block);
    class_addMethod(metaClass, selector, imp, types);
}

+ (void)configureCanHandleNavigationSetupMethod {
    SEL canHandleNavigationSetupSelector = @selector(canHandleNavigationSetup:);
    Method method = class_getClassMethod(self, canHandleNavigationSetupSelector);
    const char *types = method_getTypeEncoding(method);

    IMP canHandleNavigationSetupMethodImplementation = imp_implementationWithBlock((id)^(id self, RLDNavigationSetup *navigationSetup) {
        return navigationSetup.destination = [self destination];
    });
    class_addMethod(self, canHandleNavigationSetupSelector, canHandleNavigationSetupMethodImplementation, types);
}

+ (void)clearExecutionRegistryAndUnregisterAllSubclasses {
    [executedCommandClasses removeAllObjects];

    NSMutableSet *availableCommandClasses = (NSMutableSet *)[RLDDirectNavigationCommand availableCommandClasses];
    do {
        Class commandClass = [availableCommandClasses anyObject];
        [availableCommandClasses removeObject:commandClass];
        objc_disposeClassPair(commandClass);
    } while ([availableCommandClasses count]);
}

+ (BOOL)hasExecutionOrder:(NSArray *)executionOrder {
    return [executedCommandClasses compareContentsWith:executionOrder];;
}

+ (BOOL)executed {
    return [executedCommandClasses containsObject:self];
}

- (void)execute {
    [executedCommandClasses addObject:[self class]];

    [super execute];
}

@end

@implementation RLDCountingNavigationController

- (instancetype)init {
    if (self = [super init]) {
        [self resetCounters];
    }
    return self;
}

- (void)resetCounters {
    _pushCount = 0;
    _popCount = 0;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _pushCount++;
    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _popCount++;
    return [super popToViewController:viewController animated:animated];
}

- (void)setRootViewControllerWithClass:(Class)class {
    [self setClassChain:@[class]];
}

- (BOOL)hasClassChain:(NSArray *)classChain {
    return [self.viewControllers compareContentsWith:classChain];;
}

- (void)setClassChain:(NSArray *)classChain {
    [self setViewControllers:@[]];
    for (Class class in classChain) {
        UIViewController *viewController = [[class alloc] init];
        [self pushViewController:viewController animated:NO];
    }
    [self resetCounters];
}

@end