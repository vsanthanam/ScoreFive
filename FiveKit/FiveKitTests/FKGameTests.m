//
//  FKGameTests.m
//  FiveKitTests
//
//  Created by Varun Santhanam on 6/8/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import XCTest;

#import "FiveKit.h"

@interface FKGameTests : XCTestCase

@property (nonatomic, strong) NSOrderedSet<NSString *> *testPlayers;

@end

@implementation FKGameTests

- (void)setUp {
    
    [super setUp];
    self.testPlayers = [NSOrderedSet<NSString *> orderedSetWithArray:@[@"Mom", @"Dad", @"God", @"Bro"]];

}

- (void)tearDown {

    self.testPlayers = nil;
    [super tearDown];
    
}

- (void)testCreateGame {
    
    FKGame *game = [[FKGame alloc] initWithPlayers:self.testPlayers scoreLimit:300];
    XCTAssertTrue([game.players isEqualToOrderedSet:self.testPlayers]);
    XCTAssertTrue(game.scoreLimit == 300);
    
}

@end
