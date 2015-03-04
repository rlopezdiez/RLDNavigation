#import "RLDContactCardViewModel.h"

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