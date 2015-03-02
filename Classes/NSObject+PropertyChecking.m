#import "NSObject+PropertyChecking.h"

#import <objc/runtime.h>

@implementation NSObject (PropertyChecking)

- (BOOL)hasProperty:(NSString *)propertyName {
    return ([self propertyWithName:propertyName] != NULL);
}

- (BOOL)canSetProperty:(NSString *)propertyName {
    objc_property_t property = [self propertyWithName:propertyName];
    if (property == NULL) return NO;
    
    char *readonly = property_copyAttributeValue(property, "R");

    return !readonly;
}

- (objc_property_t)propertyWithName:(NSString *)propertyName {
    if (![propertyName length]) return NULL;

    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    
    return property;
}


@end