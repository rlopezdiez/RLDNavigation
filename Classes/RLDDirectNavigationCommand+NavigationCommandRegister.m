#import "RLDDirectNavigationCommand+NavigationCommandRegister.h"

#import <objc/runtime.h>

static NSMutableSet *_availableCommandClasses;

@implementation RLDDirectNavigationCommand (NavigationCommandRegister)

+ (void)registerClassesConformingToNavigationCommandProtocol {
    _availableCommandClasses = [NSMutableSet set];
    
    int classesCount = objc_getClassList(NULL, 0);
    Class* classes = (Class *)malloc(sizeof(Class) * classesCount);
    classesCount = objc_getClassList(classes, classesCount);
    
    for (NSUInteger index = 0; index < classesCount; index++) {
        Class class = classes[index];
        
        if (class != self
            && [self classConformsToNavigationCommandProtocol:class]
            && [class destination]) {
            [_availableCommandClasses addObject:class];
        }
    }
    free(classes);
}

+ (BOOL)classConformsToNavigationCommandProtocol:(Class)class {
    // class_conformsToProtocol is not recursive!
    BOOL classIsNavigationCommand = class_conformsToProtocol(class, @protocol(RLDNavigationCommand));
    if (classIsNavigationCommand) return YES;
    
    Class superclass = class_getSuperclass(class);
    return (superclass
            ? [self classConformsToNavigationCommandProtocol:superclass]
            : NO);
}

- (NSSet *)availableCommandClasses {
    return _availableCommandClasses;
}

@end