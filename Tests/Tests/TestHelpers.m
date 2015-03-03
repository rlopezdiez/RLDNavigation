#import "TestHelpers.h"

#import <objc/runtime.h>

#import "RLDNavigationSetup.h"
#import "RLDDirectNavigationCommand+NavigationCommandRegister.h"

@implementation NSObject (TestingHelpers)

+ (Class)registerSubclassWithName:(NSString *)name {
    Class class = objc_getClass([name UTF8String]);
    if (!class) {
        class = objc_allocateClassPair(self, [name UTF8String], 0);
        objc_registerClassPair(class);
    }
    return class;
}

@end

@implementation RLDPushPopNavigationCommand (TestingHelpers)

+ (Class)registerSubclassWithName:(NSString *)name origins:(NSArray *)origins destination:(Class)destination {
    Class newClass = [self registerSubclassWithName:name];
    
    [newClass setReturnValue:origins forSelector:@selector(origins)];
    [newClass setReturnValue:destination forSelector:@selector(destination)];
    [newClass setReturnValue:nil forSelector:@selector(nibName)];
    [newClass setReturnValue:nil forSelector:@selector(viewControllerStoryboardIdentifier)];
    [newClass setReturnValue:nil forSelector:@selector(animatesTransitions)];
    
    [newClass configureCanHandleNavigationSetupMethod];
        
    [RLDDirectNavigationCommand registerClassesConformingToNavigationCommandProtocol];
    
    return newClass;
}

+ (void)setReturnValue:(id)returnValue forSelector:(SEL)selector {
    // If we don't use the metaclass, class_addMethod will add an instance method
    Class metaClass = objc_getMetaClass([NSStringFromClass(self) UTF8String]);
    
    Method method = class_getClassMethod(metaClass, selector);
    const char *types = method_getTypeEncoding(method);
    IMP imp = [self impReturning:returnValue];
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

+ (IMP)impReturning:(id)returnValue {
    return imp_implementationWithBlock((id)^(id self) {
        return returnValue;
    });
}

+ (void)unregisterAllSubclasses {
    NSMutableSet *availableCommandClasses = (NSMutableSet *)[RLDDirectNavigationCommand availableCommandClasses];
    do {
        Class commandClass = [availableCommandClasses anyObject];
        [availableCommandClasses removeObject:commandClass];
        objc_disposeClassPair(commandClass);
    } while ([availableCommandClasses count]);
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
    if ([classChain count] != [self.viewControllers count]) return NO;
    
    __block BOOL hasClassChain = YES;
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj class] != classChain[idx]) {
            hasClassChain = NO;
            *stop = YES;
        }
        
    }];
    
    return hasClassChain;
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