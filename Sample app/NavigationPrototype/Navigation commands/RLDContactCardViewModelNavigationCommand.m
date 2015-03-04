#import "RLDContactCardViewModelNavigationCommand.h"
#import "RLDContactCardViewModel.h"

static NSString *const destinationClassName = @"RLDContactCardViewController";

@implementation RLDContactCardViewModelNavigationCommand

#pragma mark - Suitability checking

+ (BOOL)canHandleNavigationSetup:(RLDNavigationSetup *)navigationSetup {
    RLDContactCardViewModel *viewModel = navigationSetup.properties[@"viewModel"];
    return [viewModel isKindOfClass:[RLDContactCardViewModel class]];
}

+ (Class)destination {
    return NSClassFromString(destinationClassName);
}

+ (NSString *)viewControllerStoryboardIdentifier {
    return destinationClassName;
}

- (void)execute {
    [super execute];
}

@end
