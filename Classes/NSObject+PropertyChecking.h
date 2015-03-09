#import <Foundation/Foundation.h>

@interface NSObject (PropertyChecking)

- (BOOL)hasProperty:(NSString *)propertyName;
- (BOOL)canSetProperty:(NSString *)propertyName;
- (void)setProperties:(NSDictionary *)properties;

@end