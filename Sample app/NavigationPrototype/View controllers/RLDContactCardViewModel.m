#import "RLDContactCardViewModel.h"

static NSString *const destinationClassName = @"RLDContactCardViewController";

@implementation RLDContactCardViewModel

+ (instancetype)viewModelWithName:(NSString *)name
                          surname:(NSString *)surname
                            email:(NSString *)email {
    RLDContactCardViewModel* viewModel = [[self alloc] init];
    if (viewModel) {
        viewModel.name = name;
        viewModel.surname = surname;
        viewModel.email = email;
    }
    return viewModel;
}

@end

@implementation RLDNavigationSetup (RLDContactCardViewModelNavigationCommand)

+ (instancetype)setupWithViewModel:(RLDContactCardViewModel *)viewModel
              navigationController:(UINavigationController *)navigationController {
    if (![viewModel isKindOfClass:[RLDContactCardViewModel class]]) return nil;
    
    return [self setupWithDestination:NSClassFromString(destinationClassName)
                           properties:@{@"viewModel" : viewModel}
                 navigationController:navigationController];
    
}

@end