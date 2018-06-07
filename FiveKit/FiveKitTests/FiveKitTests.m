//
//  FiveKitTests.m
//  FiveKitTests
//
//  Created by Varun Santhanam on 6/3/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "FiveKit.h"

@interface FiveKitTests : XCTestCase

@end

@implementation FiveKitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRoundCreate {
    
    NSOrderedSet<NSString *> *players = [NSOrderedSet<NSString *> orderedSetWithArray:@[@"Mom", @"Dad", @"God", @"Bro"]];
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:players];
    
    XCTAssertEqual(round.players, players);
    
}

- (void)testRoundInitialCompleteness {
    
    NSOrderedSet<NSString *> *players = [NSOrderedSet<NSString *> orderedSetWithArray:@[@"Mom", @"Dad", @"God", @"Bro"]];
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:players];
    
    XCTAssertFalse(round.complete);
    
}

- (void)testRoundInitialScores {
    
    NSOrderedSet<NSString *> *players = [NSOrderedSet<NSString *> orderedSetWithArray:@[@"Mom", @"Dad", @"God", @"Bro"]];
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:players];
    
    XCTAssertNil([round scoreForPlayer:@"Mom"]);
    XCTAssertNil([round scoreForPlayer:@"Dad"]);
    XCTAssertNil([round scoreForPlayer:@"God"]);
    XCTAssertNil([round scoreForPlayer:@"Bro"]);
    
}

- (void)testRoundScoring {
    
    NSOrderedSet<NSString *> *players = [NSOrderedSet<NSString *> orderedSetWithArray:@[@"Mom", @"Dad", @"God", @"Bro"]];
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:players];
    
    [round setScore:@23 forPlayer:@"Mom"];
    [round setScore:@0 forPlayer:@"Dad"];
    [round setScore:@12 forPlayer:@"God"];
    [round setScore:@19 forPlayer:@"Bro"];
    
    XCTAssertEqual([round scoreForPlayer:@"Mom"], @23);
    XCTAssertEqual([round scoreForPlayer:@"Dad"], @0);
    XCTAssertEqual([round scoreForPlayer:@"God"], @12);
    XCTAssertEqual([round scoreForPlayer:@"Bro"], @19);
    
}

- (void)testRoundScoringCompleteness {
    
    NSOrderedSet<NSString *> *players = [NSOrderedSet<NSString *> orderedSetWithArray:@[@"Mom", @"Dad", @"God", @"Bro"]];
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:players];
    
    [round setScore:@23 forPlayer:@"Mom"];
    [round setScore:@0 forPlayer:@"Dad"];
    [round setScore:@12 forPlayer:@"God"];
    [round setScore:@19 forPlayer:@"Bro"];
    
    XCTAssertTrue(round.complete);
    
}

- (void)testRoundInvalidScoring {
    
    NSOrderedSet<NSString *> *players = [NSOrderedSet<NSString *> orderedSetWithArray:@[@"Mom", @"Dad", @"God", @"Bro"]];
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:players];
    
    XCTAssertThrows([round setScore:@(-1) forPlayer:@"Mom"]);
    XCTAssertThrows([round setScore:@51 forPlayer:@"Dad"]);
    
}

@end
