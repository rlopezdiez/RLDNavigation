#import <Foundation/Foundation.h>

#import "RLDNavigationSetup+RLDContactCardViewModel.h"

@interface RLDContactCardViewModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *surname;
@property (copy, nonatomic) NSString *email;

+ (instancetype)viewModelWithName:(NSString *)name
                          surname:(NSString *)surname
                            email:(NSString *)email;

@end