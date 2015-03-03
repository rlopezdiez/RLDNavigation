#import "RLDNavigationSetup.h"

@implementation RLDNavigationSetup

#pragma mark - Factory method and initialization

+ (instancetype)setuptWithDestination:(Class)destination
                 navigationController:(UINavigationController *)navigationController {
    return [self setupWithDestination:destination
                           properties:nil
                          breadcrumbs:nil
                 navigationController:navigationController];
}

+ (instancetype)setuptWithDestination:(Class)destination
                          breadcrumbs:(NSArray *)breadcrumbs
                 navigationController:(UINavigationController *)navigationController {
    return [self setupWithDestination:destination
                           properties:nil
                          breadcrumbs:breadcrumbs
                 navigationController:navigationController];
}

+ (instancetype)setupWithDestination:(Class)destination
                          properties:(NSDictionary *)properties
                navigationController:(UINavigationController *)navigationController {
    return [self setupWithDestination:destination
                           properties:properties
                          breadcrumbs:nil
                 navigationController:navigationController];
}

+ (instancetype)setupWithDestination:(Class)destination
                          properties:(NSDictionary *)properties
                         breadcrumbs:(NSArray *)breadcrumbs
                navigationController:(UINavigationController *)navigationController {
    Class origin = navigationController.topViewController.class;
    return [[self alloc] initWithOrigin:origin
                            destination:destination
                             properties:properties
                            breadcrumbs:breadcrumbs
                   navigationController:navigationController];
}

- (instancetype)initWithOrigin:(Class)origin
                   destination:(Class)destination
                    properties:(NSDictionary *)properties
                   breadcrumbs:(NSArray *)breadcrumbs
          navigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        _origin = origin;
        _destination = destination;
        _properties = [properties copy];
        _breadcrumbs = [breadcrumbs copy];
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    RLDNavigationSetup *copy = [[self.class alloc] init];
    if (copy) {
        copy->_origin = self->_origin;
        copy->_destination = self->_destination;
        copy->_properties = self->_properties;
        copy->_breadcrumbs = self->_breadcrumbs;
        copy->_navigationController = self->_navigationController;
    }
    return copy;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; navigationController: %@; origin: %@; destination: %@; properties: %@; breadcrumbs: %@>",
            [self class],
            self,
            self.navigationController,
            self.origin,
            self.destination,
            self.properties,
            self.breadcrumbs];
}

@end