#import "RLDContactCardViewController.h"

#import "RLDNavigation.h"
#import "RLDContactCardViewModel.h"

@interface RLDContactCardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *surname;
@property (weak, nonatomic) IBOutlet UILabel *email;

@end

@implementation RLDContactCardViewController

- (void)setViewModel:(RLDContactCardViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.name.text = viewModel.name;
    self.surname.text = viewModel.surname;
    self.email.text = viewModel.email;
}

@end
