#import "RLDNavigationSetup+URLs.h"

#import <UIKit/UIKit.h>

@implementation RLDNavigationSetup (URLs)

#pragma mark - Path component to class mapping

+ (NSDictionary *)pathComponentToClassMap {
    // This should be ideally stored in a config file somewhere
    return @{@"menu" : NSClassFromString(@"RLDMenuViewController"),
             @"folder" : NSClassFromString(@"RLDFolderViewController"),
             @"connections" : NSClassFromString(@"RLDConnectionsViewController"),
             @"chat" : NSClassFromString(@"RLDChatViewController"),
             @"profile" : NSClassFromString(@"RLDProfileViewController"),
             @"contact": NSClassFromString(@"RLDContactCardViewController")};
}


+ (instancetype)setupWithUrl:(NSString *)url
        navigationController:(UINavigationController *)navigationController {
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:url];
    NSString *path = [urlComponents path];
    if (![path length]) return nil;
    
    NSArray *pathComponents = [path componentsSeparatedByString:@"/"];
    NSMutableArray *milestones = [self milestonesForPathComponents:pathComponents];
    if (![milestones count]) return nil;
    
    Class destination = [milestones lastObject];
    
    [milestones removeLastObject];
    NSArray *breadcrumbs = [milestones copy];
    
    NSDictionary *properties = [self propertiesWithQuery:[urlComponents query]];
    
    return [self setupWithDestination:destination
                           properties:properties
                          breadcrumbs:breadcrumbs
                 navigationController:navigationController];
}

+ (NSMutableArray *)milestonesForPathComponents:(NSArray *)pathComponents {
    NSMutableArray *breadcrumbs = [NSMutableArray arrayWithCapacity:[pathComponents count]];
    for (NSString *pathComponent in pathComponents) {
        Class class = [self classforPathComponent:pathComponent];
        if (!class) return nil;
        
        [breadcrumbs addObject:class];
    }
    return breadcrumbs;
}

+ (Class)classforPathComponent:(NSString *)pathComponent {
    return [[self class] pathComponentToClassMap][pathComponent];
}

+ (NSDictionary *)propertiesWithQuery:(NSString *)query {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    NSScanner *queryScanner = [NSScanner scannerWithString:query];
    
    NSCharacterSet *controlCharacters = [NSCharacterSet characterSetWithCharactersInString:@"&?="];
    [queryScanner setCharactersToBeSkipped:controlCharacters];
    
    NSString *keyOrValue, *key, *value;
    while ([queryScanner scanUpToCharactersFromSet:controlCharacters intoString:&keyOrValue]) {
        value = key ? keyOrValue : nil;
        key = key ?: keyOrValue;
        if (key && value) {
            properties[key] = value;
            key = value = nil;
        }
    }

    return [properties copy];
}

@end