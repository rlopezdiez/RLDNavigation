#import <Foundation/Foundation.h>

#import "RLDNavigationSetup.h"

@interface RLDContactCardViewModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *surname;
@property (copy, nonatomic) NSString *email;

+ (instancetype)viewModelWithName:(NSString *)name
                          surname:(NSString *)surname
                            email:(NSString *)email;

@end

@interface RLDNavigationSetup (RLDContactCardViewModelNavigationCommand)

+ (instancetype)setupWithViewModel:(RLDContactCardViewModel *)viewModel
              navigationController:(UINavigationController *)navigationController;

@end
