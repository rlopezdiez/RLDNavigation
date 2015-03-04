#import <UIKit/UIKit.h>
#import "RLDNavigationSetup.h"

@class RLDContactCardViewModel;

@interface RLDNavigationSetup (RLDContactCardViewModel)

+ (instancetype)setupWithViewModel:(RLDContactCardViewModel *)viewModel
              navigationController:(UINavigationController *)navigationController;

@end
