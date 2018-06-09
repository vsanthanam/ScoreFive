//
//  FiveKitTests.m
//  FiveKitTests
//
//  Created by Varun Santhanam on 6/3/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import XCTest;

#import "FiveKit.h"

@interface FKRoundScoreTests : XCTestCase

@property (nonatomic, strong) NSOrderedSet<NSString *> *testPlayers;

@end

@implementation FKRoundScoreTests

- (void)setUp {
    
    [super setUp];
    self.testPlayers = [NSOrderedSet<NSString *> orderedSetWithArray:@[@"Mom", @"Dad", @"God", @"Bro"]];
    
}

- (void)tearDown {

    self.testPlayers = nil;
    [super tearDown];
    
}

- (void)testRoundCreate {
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:self.testPlayers];
    
    XCTAssertEqual(round.players, self.testPlayers);
    
}

- (void)testRoundInitialCompleteness {
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:self.testPlayers];
    
    XCTAssertFalse(round.complete);
    
}

- (void)testRoundInitialScores {
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:self.testPlayers];
    
    XCTAssertNil([round scoreForPlayer:@"Mom"]);
    XCTAssertNil([round scoreForPlayer:@"Dad"]);
    XCTAssertNil([round scoreForPlayer:@"God"]);
    XCTAssertNil([round scoreForPlayer:@"Bro"]);
    
}

- (void)testRoundScoring {
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:self.testPlayers];
    
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
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:self.testPlayers];
    
    [round setScore:@23 forPlayer:@"Mom"];
    [round setScore:@0 forPlayer:@"Dad"];
    [round setScore:@12 forPlayer:@"God"];
    [round setScore:@19 forPlayer:@"Bro"];
    
    XCTAssertTrue(round.complete);
    
}

- (void)testRoundInvalidScoring {
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:self.testPlayers];
    
    XCTAssertThrows([round setScore:@(-1) forPlayer:@"Mom"]);
    XCTAssertThrows([round setScore:@51 forPlayer:@"Dad"]);
    
}

- (void)testRoundScoreKeyedSubscripting {
    
    FKRoundScore *round = [FKRoundScore roundScoreWithPlayers:self.testPlayers];
    
    round[@"Mom"] = @23;
    round[@"Dad"] = @0;
    round[@"God"] = @12;
    round[@"Bro"] = @19;
    
    XCTAssertEqual(round[@"Mom"], @23);
    XCTAssertEqual(round[@"Dad"], @0);
    XCTAssertEqual(round[@"God"], @12);
    XCTAssertEqual(round[@"Bro"], @19);
    
}

- (void)testRoundEquality {
    
    FKRoundScore *round1 = [FKRoundScore roundScoreWithPlayers:self.testPlayers];
    FKRoundScore *round2 = [FKRoundScore roundScoreWithPlayers:self.testPlayers];
    
    XCTAssertTrue([round1 isEqualToRoundScore:round2]);
    XCTAssertTrue([round1 isEqual:round2]);
    XCTAssertTrue([round2 isEqualToRoundScore:round1]);
    XCTAssertTrue([round2 isEqual:round1]);
    
    round2[@"Mom"] = @23;
    
    XCTAssertFalse([round1 isEqualToRoundScore:round2]);
    XCTAssertFalse([round1 isEqual:round2]);
    XCTAssertFalse([round2 isEqualToRoundScore:round1]);
    XCTAssertFalse([round2 isEqual:round1]);
    
}

@end
