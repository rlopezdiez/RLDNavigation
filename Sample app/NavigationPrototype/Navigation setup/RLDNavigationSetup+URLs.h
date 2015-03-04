#import <UIKit/UIKit.h>
#import "RLDNavigationSetup.h"

@class UINavigationController;

@interface RLDNavigationSetup (URL)

+ (instancetype)setupWithUrl:(NSString *)url
        navigationController:(UINavigationController *)navigationController;

@end
