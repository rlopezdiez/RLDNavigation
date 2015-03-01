#import "NSObject+KeyValueCompliance.h"

@implementation NSObject (KeyValueCompliance)

- (BOOL)isKeyValueCompliantForKey:(NSString *)key {
    NSString *setterName = [NSString stringWithFormat: @"set%@:", [key capitalizedString]];
    SEL selectorForSetter = NSSelectorFromString(setterName);
    return [self respondsToSelector:selectorForSetter];
}

@end