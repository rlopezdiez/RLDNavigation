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

static NSString *const firstViewControllerWithPropertiesClassName = @"RLDFirstViewControllerWithProperties";
static NSString *const secondViewControllerWithPropertiesClassName = @"RLDSecondViewControllerWithProperties";

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
    [RLDTestingNavigationCommand clearExecutionRegistryAndUnregisterAllSubclasses];
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

#pragma mark - General navigation test cases

- (void)testDirectNavigation {
    // GIVEN:
    //   Two view controller classes (1, 2)
    //   a navigation controller with an instance of the 1st class as the root view controller
    //   a navigation command between the two classes (1 > 2)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    
    Class navigationCommandClass = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
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
    //   the navigation controller has pushed once, without any pop
    //   the navigation command has been executed
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertEqual(navigationController.pushCount, 1);
    XCTAssertEqual(navigationController.popCount, 0);
    XCTAssertTrue([navigationCommandClass executed]);
}

- (void)testNavigationConservation {
    // GIVEN:
    //   Two view controller classes (1, 2)
    //   a navigation controller with the class chain 1 > 2
    //   a navigation command (1 > 2)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass];
    [navigationController setClassChain:expectedClassChain];
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:secondViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the 2nd view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:secondViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2
    //   the navigation comands haven't been executed
    //   the navigation controller hasn't pushed nor popped
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertFalse([firstNavigationCommand executed]);
    XCTAssertEqual(navigationController.pushCount, 0);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testPopToPrevious {
    // GIVEN:
    //   Three view controller classes (1, 2, 3)
    //   a navigation controller with the class chain 1 > 2 > 3
    //   one navigation commands (1 > 2)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    
    [navigationController setClassChain:@[firstViewControllerClass,
                                          secondViewControllerClass,
                                          thirdViewControllerClass]];
    
    Class navigationCommandClass = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:secondViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the 2nd view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:secondViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   the class chain will be 1 > 2
    //   the navigation controller has popped once, without any push
    //   the navigation command has been executed
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertEqual(navigationController.pushCount, 0);
    XCTAssertEqual(navigationController.popCount, 1);
    XCTAssertTrue([navigationCommandClass executed]);
}

#pragma mark - Path searching test cases

- (void)testForwardPathSearching {
    // GIVEN:
    //   Five view controller classes (1, 2, 3, 4, 5)
    //   a navigation controller with the class chain 1 > 2 > 3
    //   two navigation commands (3 > 4), (4 > 5)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    Class fourthViewControllerClass = NSClassFromString(fourthViewControllerClassName);
    Class fifthViewControllerClass = NSClassFromString(fifthViewControllerClassName);
    
    [navigationController setClassChain:@[firstViewControllerClass,
                                          secondViewControllerClass,
                                          thirdViewControllerClass]];
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFourthViewController"
                                                                                 origins:@[thirdViewControllerClass]
                                                                             destination:fourthViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFourToFifthViewController"
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
    //   the navigation commands have been executed 1 > 2
    //   the navigation controller has pushed twice, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass,
                                    fourthViewControllerClass,
                                    fifthViewControllerClass];
    NSArray *expectedExecutionOrder = @[firstNavigationCommand,
                                        secondNavigationCommand];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertTrue([RLDTestingNavigationCommand hasExecutionOrder:expectedExecutionOrder]);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testPopBeforePathSearching {
    // GIVEN:
    //   Four view controller classes (1, 2, 3, 4)
    //   a navigation controller with the class chain 1 > 4
    //   three navigation commands (*, 1), (1 > 2), (2 > 3)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    Class fourthViewControllerClass = NSClassFromString(fourthViewControllerClassName);
    
    [navigationController setClassChain:@[firstViewControllerClass,
                                          fourthViewControllerClass]];
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandToFirstViewController"
                                                                                 origins:nil
                                                                             destination:firstViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                                                  origins:@[firstViewControllerClass]
                                                                              destination:secondViewControllerClass];
    
    Class thirdNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                                                 origins:@[secondViewControllerClass]
                                                                             destination:thirdViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the 3rd view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:thirdViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2 > 3 > 4
    //   the navigation commands have been executed 1 > 2 > 3
    //   the navigation controller has pushed twice, popped once
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass];
    NSArray *expectedExecutionOrder = @[firstNavigationCommand,
                                        secondNavigationCommand,
                                        thirdNavigationCommand];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertTrue([RLDTestingNavigationCommand hasExecutionOrder:expectedExecutionOrder]);
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
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:secondViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                                                  origins:@[secondViewControllerClass]
                                                                              destination:thirdViewControllerClass];
    
    Class thirdNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFourthViewController"
                                                                                 origins:@[thirdViewControllerClass]
                                                                             destination:fourthViewControllerClass];
    
    Class fourthNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFourToFifthViewController"
                                                                                  origins:@[fourthViewControllerClass]
                                                                              destination:fifthViewControllerClass];
    
    Class fifthNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFistToThirdViewController"
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:thirdViewControllerClass];
    
    Class sixthNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFifthViewController"
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
    //   the 5th and 6th navigation commands have been executed 5 > 6
    //   the navigation commands from 1st to 4th haven't been executed
    //   the navigation controller has pushed twice, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    thirdViewControllerClass,
                                    fifthViewControllerClass];
    NSArray *expectedExecutionOrder = @[fifthNavigationCommand,
                                        sixthNavigationCommand];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertTrue([RLDTestingNavigationCommand hasExecutionOrder:expectedExecutionOrder]);
    XCTAssertFalse([firstNavigationCommand executed]);
    XCTAssertFalse([secondNavigationCommand executed]);
    XCTAssertFalse([thirdNavigationCommand executed]);
    XCTAssertFalse([fourthNavigationCommand executed]);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 0);
}

#pragma mark - Wildcard origings test cases

- (void)testWildcardOriginsPathSearching {
    // GIVEN:
    //   Three view controller classes (1, 2, 3)
    //   a navigation controller with an instance of the 1st class as the root view controller
    //   two navigation commands (* > 2), (2 > 3)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    
    [navigationController setRootViewControllerWithClass:firstViewControllerClass];
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandToSecondViewController"
                                                                                 origins:nil
                                                                             destination:secondViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                                                  origins:@[secondViewControllerClass]
                                                                              destination:thirdViewControllerClass];
    
    
    // WHEN:
    //   We create a set up asking to navigate to the 3rd view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:thirdViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2 > 3
    //   the navigation commands have been executed 1 > 2
    //   the navigation controller has pushed twice, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass];
    NSArray *expectedExecutionOrder = @[firstNavigationCommand,
                                        secondNavigationCommand];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertTrue([RLDTestingNavigationCommand hasExecutionOrder:expectedExecutionOrder]);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testWildcardOriginsBestRouteFinding {
    // GIVEN:
    //   Five view controller classes (1, 2, 3, 4, 5)
    //   a navigation controller with an instance of the 1st class as the root view controller
    //   six navigation commands (1 > 2), (2 > 3), (3 > 4), (4, 5), (* > 3), (* > 4)
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = NSClassFromString(thirdViewControllerClassName);
    Class fourthViewControllerClass = NSClassFromString(fourthViewControllerClassName);
    Class fifthViewControllerClass = NSClassFromString(fifthViewControllerClassName);
    
    [navigationController setRootViewControllerWithClass:firstViewControllerClass];
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:secondViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                                                  origins:@[secondViewControllerClass]
                                                                              destination:thirdViewControllerClass];
    
    Class thirdNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFourthViewController"
                                                                                 origins:@[thirdViewControllerClass]
                                                                             destination:fourthViewControllerClass];
    
    Class fourthNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFourToFifthViewController"
                                                                                  origins:@[fourthViewControllerClass]
                                                                              destination:fifthViewControllerClass];
    
    Class fifthNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandToThirdViewController"
                                                                                 origins:nil
                                                                             destination:thirdViewControllerClass];
    
    Class sixthNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandToFourthViewController"
                                                                                 origins:nil
                                                                             destination:fourthViewControllerClass];
    
    // WHEN:
    //   We create a set up asking to navigate to the 5th view controller class
    //   and we execute it
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:fifthViewControllerClass
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 3 > 5
    //   the 4th and 5th navigation commands have been executed 6 > 4
    //   the 1st, 2nd, 3rd, 5th navigation commands haven't been executed
    //   the navigation controller has pushed twice, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    fourthViewControllerClass,
                                    fifthViewControllerClass];
    NSArray *expectedExecutionOrder = @[sixthNavigationCommand,
                                        fourthNavigationCommand];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertTrue([RLDTestingNavigationCommand hasExecutionOrder:expectedExecutionOrder]);
    XCTAssertFalse([firstNavigationCommand executed]);
    XCTAssertFalse([secondNavigationCommand executed]);
    XCTAssertFalse([thirdNavigationCommand executed]);
    XCTAssertFalse([fifthNavigationCommand executed]);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 0);
}

#pragma mark - Breadcrumbs test cases

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
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:secondViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                                                  origins:@[secondViewControllerClass]
                                                                              destination:thirdViewControllerClass];
    
    Class thirdNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFourthViewController"
                                                                                 origins:@[thirdViewControllerClass]
                                                                             destination:fourthViewControllerClass];
    
    Class fourthNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFourToFifthViewController"
                                                                                  origins:@[fourthViewControllerClass]
                                                                              destination:fifthViewControllerClass];
    
    Class fifthNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFistToThirdViewController"
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:thirdViewControllerClass];
    
    Class sixthNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromThirdToFifthViewController"
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
    //   the navigation commands from 1st to 4th have been executed 1 > 2 > 3 > 4
    //   the 5th and 6th navigation commands haven't been executed
    //   the navigation controller has pushed four times, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass,
                                    fourthViewControllerClass,
                                    fifthViewControllerClass];
    
    NSArray *expectedExecutionOrder = @[firstNavigationCommand,
                                        secondNavigationCommand,
                                        thirdNavigationCommand,
                                        fourthNavigationCommand];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertTrue([RLDTestingNavigationCommand hasExecutionOrder:expectedExecutionOrder]);
    XCTAssertFalse([fifthNavigationCommand executed]);
    XCTAssertFalse([sixthNavigationCommand executed]);
    XCTAssertEqual(navigationController.pushCount, 4);
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
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandToFirstViewController"
                                                                                 origins:nil
                                                                             destination:firstViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                                                  origins:@[firstViewControllerClass]
                                                                              destination:secondViewControllerClass];
    
    Class thirdNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
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
    //   the navigation comands haven't been executed
    //   the navigation controller hasn't pushed nor popped
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertFalse([firstNavigationCommand executed]);
    XCTAssertFalse([secondNavigationCommand executed]);
    XCTAssertFalse([thirdNavigationCommand executed]);
    XCTAssertEqual(navigationController.pushCount, 0);
    XCTAssertEqual(navigationController.popCount, 0);
}

#pragma mark - Property propagation test cases

- (void)testPropertyPropagation {
    // GIVEN:
    //   Three view controller classes (1, 2, 3)
    //   the 2nd and 3rd ones have a readwrite property
    //   a navigation controller with an instance of the 1st class as the root view controller
    //   two navigation commands (1 > 2), (2 > 3)
    NSString *propertyName = @"propertyName";
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = [UIViewController registerSubclassWithName:firstViewControllerWithPropertiesClassName
                                                              readonlyProperties:nil
                                                             readwriteProperties:@[propertyName]];
    Class thirdViewControllerClass = [UIViewController registerSubclassWithName:secondViewControllerWithPropertiesClassName
                                                             readonlyProperties:nil
                                                            readwriteProperties:@[propertyName]];
    
    [navigationController setRootViewControllerWithClass:firstViewControllerClass];
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:secondViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                                                  origins:@[secondViewControllerClass]
                                                                              destination:thirdViewControllerClass];
    
    
    // WHEN:
    //   We create a set up asking to navigate to the 3rd view controller class
    //   propagating the readwrite property
    //   and we execute it
    NSString *propertyValue = @"expectedValue";
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:thirdViewControllerClass
                                                                        properties:@{propertyName : propertyValue}
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2 > 3
    //   the 2nd and 3rd view controllers in the navigation stack will have the propagated property set
    //   the navigation commands have been executed 1 > 2
    //   the navigation controller has pushed twice, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass];
    NSArray *expectedExecutionOrder = @[firstNavigationCommand,
                                        secondNavigationCommand];
    BOOL secondViewControllerHasPropertySet = [[navigationController.viewControllers[1] valueForKey:propertyName] isEqual:propertyValue];
    BOOL thirdViewControllerHasPropertySet = [[navigationController.viewControllers[2] valueForKey:propertyName] isEqual:propertyValue];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertTrue(secondViewControllerHasPropertySet);
    XCTAssertTrue(thirdViewControllerHasPropertySet);
    XCTAssertTrue([RLDTestingNavigationCommand hasExecutionOrder:expectedExecutionOrder]);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testReadonlyPropertyConservation {
    // GIVEN:
    //   Three view controller classes (1, 2, 3)
    //   the 2nd one has a readonly property
    //   the 3rd one has a readwrite property with the same name
    //   two navigation commands (1 > 2), (2 > 3)
    NSString *propertyName = @"propertyName";
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = [UIViewController registerSubclassWithName:firstViewControllerWithPropertiesClassName
                                                              readonlyProperties:@[propertyName]
                                                             readwriteProperties:nil];
    Class thirdViewControllerClass = [UIViewController registerSubclassWithName:secondViewControllerWithPropertiesClassName
                                                             readonlyProperties:nil
                                                            readwriteProperties:@[propertyName]];
    
    [navigationController setRootViewControllerWithClass:firstViewControllerClass];
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromFirstToSecondViewController"
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:secondViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:@"navigationCommandFromSecondToThirdViewController"
                                                                                  origins:@[secondViewControllerClass]
                                                                              destination:thirdViewControllerClass];
    
    
    // WHEN:
    //   We create a set up asking to navigate to the 3rd view controller class
    //   propagating a readwrite property
    //   and we execute it
    NSString *propertyValue = @"expectedValue";
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:thirdViewControllerClass
                                                                        properties:@{propertyName : propertyValue}
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2 > 3
    //   the 2nd view controller in the navigation stack won't have the propagated property set
    //   the 3rd one will
    //   the navigation commands have been executed 1 > 2
    //   the navigation controller has pushed twice, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass];
    NSArray *expectedExecutionOrder = @[firstNavigationCommand,
                                        secondNavigationCommand];
    BOOL secondViewControllerHasPropertySet = [[navigationController.viewControllers[1] valueForKey:propertyName] isEqual:propertyValue];
    BOOL thirdViewControllerHasPropertySet = [[navigationController.viewControllers[2] valueForKey:propertyName] isEqual:propertyValue];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertFalse(secondViewControllerHasPropertySet);
    XCTAssertTrue(thirdViewControllerHasPropertySet);
    XCTAssertTrue([RLDTestingNavigationCommand hasExecutionOrder:expectedExecutionOrder]);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 0);
}

- (void)testPropertySkipping {
    // GIVEN:
    //   Three view controller classes (1, 2, 3)
    //   the 3rd one has a readwrite property
    //   a navigation controller with an instance of the 1st class as the root view controller
    //   two navigation commands (1 > 2), (2 > 3)
    NSString *propertyName = @"propertyName";
    Class firstViewControllerClass = NSClassFromString(firstViewControllerClassName);
    Class secondViewControllerClass = NSClassFromString(secondViewControllerClassName);
    Class thirdViewControllerClass = [UIViewController registerSubclassWithName:thirdViewControllerClassName
                                                             readonlyProperties:nil
                                                            readwriteProperties:@[propertyName]];
    
    [navigationController setRootViewControllerWithClass:firstViewControllerClass];
    
    Class firstNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:firstViewControllerWithPropertiesClassName
                                                                                 origins:@[firstViewControllerClass]
                                                                             destination:secondViewControllerClass];
    
    Class secondNavigationCommand = [RLDTestingNavigationCommand registerSubclassWithName:secondViewControllerWithPropertiesClassName
                                                                                  origins:@[secondViewControllerClass]
                                                                              destination:thirdViewControllerClass];
    
    
    // WHEN:
    //   We create a set up asking to navigate to the 3rd view controller class
    //   propagating the readwrite property
    //   and we execute it
    NSString *propertyValue = @"expectedValue";
    RLDNavigationSetup *navigationSetup = [RLDNavigationSetup setupWithDestination:thirdViewControllerClass
                                                                        properties:@{propertyName : propertyValue}
                                                              navigationController:navigationController];
    
    [navigationSetup go];
    
    // THEN:
    //   The class chain will be 1 > 2 > 3
    //   the 3rd view controller in the navigation stack will have the propagated property set
    //   the navigation commands have been executed 1 > 2
    //   the navigation controller has pushed twice, without any pop
    NSArray *expectedClassChain = @[firstViewControllerClass,
                                    secondViewControllerClass,
                                    thirdViewControllerClass];
    NSArray *expectedExecutionOrder = @[firstNavigationCommand,
                                        secondNavigationCommand];
    BOOL thirdViewControllerHasPropertySet = [[navigationController.viewControllers[2] valueForKey:propertyName] isEqual:propertyValue];
    
    XCTAssertTrue([navigationController hasClassChain:expectedClassChain]);
    XCTAssertTrue(thirdViewControllerHasPropertySet);
    XCTAssertTrue([RLDTestingNavigationCommand hasExecutionOrder:expectedExecutionOrder]);
    XCTAssertEqual(navigationController.pushCount, 2);
    XCTAssertEqual(navigationController.popCount, 0);
}

@end