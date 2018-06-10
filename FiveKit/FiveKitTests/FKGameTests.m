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
    
    FKGame *game = [FKGame gameWithPlayers:self.testPlayers scoreLimit:300];
    XCTAssertTrue([game.players isEqualToOrderedSet:self.testPlayers], @"Players is %@ instead of %@", game.players, self.testPlayers);
    XCTAssertTrue(game.scoreLimit == 300, @"Number of rounds is %li instead of 300", game.scoreLimit);
    XCTAssertTrue(game.numberOfRounds == 0, @"Number of rounds is %li instead of 0", game.numberOfRounds);
    XCTAssertFalse(game.finished, @"Game is finished when it shouldn't be");
    
}

- (void)testAddRound {
    
    FKGame *game = [FKGame gameWithPlayers:self.testPlayers scoreLimit:300];
    
    FKRoundScore *roundScore = [FKRoundScore roundScoreWithPlayers:game.alivePlayers];
    
    roundScore[@"Mom"] = @23;
    roundScore[@"Dad"] = @0;
    roundScore[@"God"] = @12;
    roundScore[@"Bro"] = @6;
    
    [game addRoundScore:roundScore];
    
    XCTAssertTrue(game.numberOfRounds == 1, @"Number of rounds is %li instead of 1", game.numberOfRounds);
    
}

@end
