#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TestHelpers.h"

// SUT
#import "RLDNavigation.h"

static NSString *const firstViewControllerClassName = @"RLDFirstViewController";
static NSString *const secondViewControllerClassName = @"RLDSecondViewController";
static NSString *const thirdViewControllerClassName = @"RLDThirdViewController";
static NSString *const fourthViewControllerClassName = @"RLDFourthViewController";
static NSString *const fifthViewControllerClassName = @"RLDFifthViewController";

static UINavigationController *navigationController;
static UINavigationController *navigationControllerDelegate;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    
    [self setUpNavigationController];
    [self setUpViewControllerClasses];
}

- (void)setUpViewControllerClasses {
    [UIViewController registerSubclassWithName:firstViewControllerClassName];
    [UIViewController registerSubclassWithName:secondViewControllerClassName];
    [UIViewController registerSubclassWithName:thirdViewControllerClassName];
    [UIViewController registerSubclassWithName:fourthViewControllerClassName];
    [UIViewController registerSubclassWithName:fifthViewControllerClassName];
}

- (void)setUpNavigationController {
    navigationController = [[UINavigationController alloc] init];
    
}

#pragma mark - Test cases

- (void)testTwoViewControllersOneNavigationCommand {
    // GIVEN:
    //   Two view controllers classes (1, 2),
    //   a navigation controller with an instance of the first as the root view controller
    //   a direct navigation command between the two classes (1 > 2)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    
    [navigationController setRootViewControllerWithClass:firstViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:secondViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the second view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setuptWithDestination:secondViewControllerClass
                                                               navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain must be 1 > 2
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass];
    BOOL hasExpectedClassChain = [navigationController hasClassChain:expectedClassChain];
    
    XCTAssert(hasExpectedClassChain);
}

@end