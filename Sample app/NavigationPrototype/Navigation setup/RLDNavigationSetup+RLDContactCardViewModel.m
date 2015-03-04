#import "RLDNavigationSetup+RLDContactCardViewModel.h"

#import "RLDContactCardViewModel.h"

static NSString *const destinationClassName = @"RLDContactCardViewController";

@implementation RLDNavigationSetup (RLDContactCardViewModel)

+ (instancetype)setupWithViewModel:(RLDContactCardViewModel *)viewModel
              navigationController:(UINavigationController *)navigationController {
    if (![viewModel isKindOfClass:[RLDContactCardViewModel class]]) return nil;
    
    return [self setupWithDestination:NSClassFromString(destinationClassName)
                           properties:@{@"viewModel" : viewModel}
                 navigationController:navigationController];
    
}

@end