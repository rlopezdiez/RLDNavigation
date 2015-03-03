#import "TestHelpers.h"

#import <objc/runtime.h>

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

@implementation UINavigationController (TestingHelpers)

- (void)setRootViewControllerWithClass:(Class)class {
    UIViewController *viewController = [[class alloc] init];
    self.viewControllers = @[viewController];
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

@end
