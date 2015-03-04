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

static RLDCountingNavigationController *navigationController;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    
    [self setUpNavigationController];
    [self setUpViewControllerClasses];
}

- (void)tearDown {
    [super tearDown];
    [RLDPushPopNavigationCommand unregisterAllSubclasses];
}

- (void)setUpViewControllerClasses {
    [UIViewController registerSubclassWithName:firstViewControllerClassName];
    [UIViewController registerSubclassWithName:secondViewControllerClassName];
    [UIViewController registerSubclassWithName:thirdViewControllerClassName];
    [UIViewController registerSubclassWithName:fourthViewControllerClassName];
    [UIViewController registerSubclassWithName:fifthViewControllerClassName];
}

- (void)setUpNavigationController {
    navigationController = [[RLDCountingNavigationController alloc] init];
}

#pragma mark - Test cases

- (void)testDirectNavigation {
    // GIVEN:
    //   Two view controller classes (1, 2)
    //   a navigation controller with an instance of the 1st class as the root view controller
    //   a navigation command between the two classes (1 > 2)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:secondViewControllerClass];
    
    [navigationController setRootViewControllerWithClass:firstViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the 2nd view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:secondViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain must be 1 > 2
    //   The navigation controller has pushed once, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass];
    BOOL hasExpectedClassChain = [navigationController hasClassChain:expectedClassChain];
    
    XCTAssert(hasExpectedClassChain);
    XCTAssertEqual(navigationController.pushCount, 1);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testPopToPrevious {
    // GIVEN:
    //   Three view controller classes (1, 2, 3)
    //   a navigation controller with the class chain 1 > 2 > 3
    //   two navigation commands (1 > 2), (2 > 3)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    
    [navigationController setClassChain:@[firstViewControllerClass,
                                          secondViewControllerClass,
                                          thirdViewControllerClass]];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:secondViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                  origins:@[secondViewControllerClass]
                                              destination:thirdViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the 2nd view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:secondViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2
    //   The navigation controller has popped once, without any push
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass];
    BOOL hasExpectedClassChain = [navigationController hasClassChain:expectedClassChain];
    
    XCTAssert(hasExpectedClassChain);
    XCTAssertEqual(navigationController.pushCount, 0);
    XCTAssertEqual(navigationController.popCount, 1);
}

- (void)testForwardPathSearching {
    // GIVEN:
    //   Five view controller classes (1, 2, 3, 4, 5)
    //   a navigation controller with the class chain 1 > 2 > 3
    //   four navigation commands (1 > 2), (2 > 3), (3 > 4), (4 > 5)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    Class fourthViewControllerClass = NSClassFromString(fourthViewControllerClassName);
    Class fifthViewControllerClass = NSClassFromString(fifthViewControllerClassName);
    
    [navigationController setClassChain:@[firstViewControllerClass,
                                          secondViewControllerClass,
                                          thirdViewControllerClass]];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:secondViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                  origins:@[secondViewControllerClass]
                                              destination:thirdViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFourthViewController"
                                                  origins:@[thirdViewControllerClass]
                                              destination:fourthViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFourToFifthViewController"
                                                  origins:@[fourthViewControllerClass]
                                              destination:fifthViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the 5th view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:fifthViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2 > 3 > 4 > 5
    //   The navigation controller has pushed twice, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass,
                                    fourthViewControllerClass,
                                    fifthViewControllerClass];
    BOOL hasExpectedClassChain = [navigationController hasClassChain:expectedClassChain];
    
    XCTAssert(hasExpectedClassChain);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testPopBeforePathSearching {
    // GIVEN:
    //   Five view controller classes (1, 2, 3, 4, 5)
    //   a navigation controller with the class chain 1 > 2 > 5
    //   four navigation commands (1 > 2), (2 > 3), (3 > 4), (4, 5)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    Class fourthViewControllerClass = NSClassFromString(fourthViewControllerClassName);
    Class fifthViewControllerClass = NSClassFromString(fifthViewControllerClassName);
    
    [navigationController setClassChain:@[firstViewControllerClass,
                                          secondViewControllerClass,
                                          fifthViewControllerClass]];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:secondViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                  origins:@[secondViewControllerClass]
                                              destination:thirdViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFourthViewController"
                                                  origins:@[thirdViewControllerClass]
                                              destination:fourthViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFourToFifthViewController"
                                                  origins:@[fourthViewControllerClass]
                                              destination:fifthViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the 4th view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:fourthViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2 > 3 > 4
    //   The navigation controller has pushed twice, popped once
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass,
                                    fourthViewControllerClass];
    BOOL hasExpectedClassChain = [navigationController hasClassChain:expectedClassChain];
    
    XCTAssert(hasExpectedClassChain);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 1);
}

- (void)testBestRouteFinding {
    // GIVEN:
    //   Five view controller classes (1, 2, 3, 4, 5)
    //   a navigation controller with an instance of the 1st class as the root view controller
    //   six navigation commands (1 > 2), (2 > 3), (3 > 4), (4, 5), (1 > 3), (3 > 5)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    Class fourthViewControllerClass = NSClassFromString(fourthViewControllerClassName);
    Class fifthViewControllerClass = NSClassFromString(fifthViewControllerClassName);
    
    [navigationController setRootViewControllerWithClass:firstViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:secondViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                  origins:@[secondViewControllerClass]
                                              destination:thirdViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFourthViewController"
                                                  origins:@[thirdViewControllerClass]
                                              destination:fourthViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFourToFifthViewController"
                                                  origins:@[fourthViewControllerClass]
                                              destination:fifthViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFistToThirdViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:thirdViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFifthViewController"
                                                  origins:@[thirdViewControllerClass]
                                              destination:fifthViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the 5th view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:fifthViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 3 > 5
    //   The navigation controller has pushed twice, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    thirdViewControllerClass,
                                    fifthViewControllerClass];
    BOOL hasExpectedClassChain = [navigationController hasClassChain:expectedClassChain];
    
    XCTAssert(hasExpectedClassChain);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testBreadcrumbs {
    // GIVEN:
    //   Five view controller classes (1, 2, 3, 4, 5)
    //   a navigation controller with an instance of the first as the root view controller
    //   six navigation commands (1 > 2), (2 > 3), (3 > 4), (4, 5), (1 > 3), (3 > 5)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    Class fourthViewControllerClass = NSClassFromString(fourthViewControllerClassName);
    Class fifthViewControllerClass = NSClassFromString(fifthViewControllerClassName);
    
    [navigationController setRootViewControllerWithClass:firstViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:secondViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                  origins:@[secondViewControllerClass]
                                              destination:thirdViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFourthViewController"
                                                  origins:@[thirdViewControllerClass]
                                              destination:fourthViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFourToFifthViewController"
                                                  origins:@[fourthViewControllerClass]
                                              destination:fifthViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFistToThirdViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:thirdViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFifthViewController"
                                                  origins:@[thirdViewControllerClass]
                                              destination:fifthViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the fifth view controller class
    //   passing by the second and fourth view controllers classes
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:fifthViewControllerClass
                                                                       breadcrumbs:@[secondViewControllerClass, fourthViewControllerClass]
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2 > 3 > 4 > 5
    //   The navigation controller has pushed four times, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass,
                                    fourthViewControllerClass,
                                    fifthViewControllerClass];
    BOOL hasExpectedClassChain = [navigationController hasClassChain:expectedClassChain];
    
    XCTAssert(hasExpectedClassChain);
    XCTAssertEqual(navigationController.pushCount, 4);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testNavigationConservation {
    // GIVEN:
    //   Three view controller classes (1, 2, 3)
    //   a navigation controller with the class chain 1 > 3
    //   two navigation commands (1 > 2), (2 > 3)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    
    [navigationController setClassChain:@[firstViewControllerClass,
                                          thirdViewControllerClass]];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:secondViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                  origins:@[secondViewControllerClass]
                                              destination:thirdViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the third view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:thirdViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 3
    //   The navigation controller hasn't pushed nor popped
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    thirdViewControllerClass];
    BOOL hasExpectedClassChain = [navigationController hasClassChain:expectedClassChain];
    
    XCTAssert(hasExpectedClassChain);
    XCTAssertEqual(navigationController.pushCount, 0);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testBreadcrumbNavigationConservation {
    // GIVEN:
    //   Three view controller classes (1, 2, 3)
    //   a navigation controller with the class chain 1 > 2 > 3
    //   three navigation commands (*, 1), (1 > 2), (2 > 3)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    
    [navigationController setClassChain:@[firstViewControllerClass,
                                          secondViewControllerClass,
                                          thirdViewControllerClass]];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandToFirstViewController"
                                                  origins:@[]
                                              destination:secondViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                  origins:@[firstViewControllerClass]
                                              destination:secondViewControllerClass];
    
    [RLDPushPopNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                  origins:@[secondViewControllerClass]
                                              destination:thirdViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the third view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:thirdViewControllerClass
                                                                       breadcrumbs:@[secondViewControllerClass]
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2 > 3
    //   The navigation controller hasn't pushed nor popped
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass];
    BOOL hasExpectedClassChain = [navigationController hasClassChain:expectedClassChain];
    
    XCTAssert(hasExpectedClassChain);
    XCTAssertEqual(navigationController.pushCount, 0);
    XCTAssertEqual(navigationController.popCount, 0);
}

@end