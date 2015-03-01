#import <Foundation/Foundation.h>

@class RLDNavigationSetup;

@protocol RLDNavigationCommand <NSObject>

+ (BOOL)canHandleNavigationSetup:(RLDNavigationSetup *)navigationSetup;

+ (NSArray *)origins;
+ (Class)destination;

- (void)execute;

@property (nonatomic, strong, readonly) RLDNavigationSetup *navigationSetup;

@end

@interface RLDNavigationCommand : NSObject <RLDNavigationCommand>

+ (instancetype)navigationCommandWithNavigationSetup:(RLDNavigationSetup *)navigationSetup;

- (instancetype)init __attribute__((unavailable("This is a class cluster. Please use the factory method.")));

@end