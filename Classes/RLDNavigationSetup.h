#import <UIKit/UIKit.h>

@interface RLDNavigationSetup : NSObject <NSCopying>

@property (nonatomic, strong) Class origin;
@property (nonatomic, strong) Class destination;
@property (nonatomic, copy) NSDictionary *properties;
@property (nonatomic, copy) NSArray *breadcrumbs;

@property (nonatomic, strong, readonly) UINavigationController *navigationController;

+ (instancetype)setuptWithDestination:(Class)destination
                 navigationController:(UINavigationController *)navigationController;

+ (instancetype)setuptWithDestination:(Class)destination
                          breadcrumbs:(NSArray *)breadcrumbs
                 navigationController:(UINavigationController *)navigationController;

+ (instancetype)setupWithDestination:(Class)destination
                          properties:(NSDictionary *)properties
                navigationController:(UINavigationController *)navigationController;

+ (instancetype)setupWithDestination:(Class)destination
                          properties:(NSDictionary *)properties
                         breadcrumbs:(NSArray *)breadcrumbs
                navigationController:(UINavigationController *)navigationController;

- (instancetype)initWithOrigin:(Class)origin
                   destination:(Class)destination
                    properties:(NSDictionary *)properties
                   breadcrumbs:(NSArray *)breadcrumbs
          navigationController:(UINavigationController *)navigationController;

@end