//
//  FKGame.m
//  FiveKit
//
//  Created by Varun Santhanam on 6/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "FKGame.h"

NSString * const FKGameIncompleteRoundScoreException = @"kFKGameIncompleteRoundScoreException";
NSString * const FKGameInvalidPlayerCountException = @"kFKGameInvalidPlayerCountException";
NSString * const FKGameInvalidScoreLimitException = @"kFKGameInvalidScoreLimitException";
NSString * const FKGameInvalidPlayerException = @"kFKGameInvalidPlayerException";

@interface FKGame ()

@property (NS_NONATOMIC_IOSONLY, copy) NSOrderedSet<NSString *> *players;
@property (NS_NONATOMIC_IOSONLY, assign) NSUInteger scoreLimit;
@property (NS_NONATOMIC_IOSONLY, strong) NSMutableArray<FKRoundScore *> *rounds;

@end

@implementation FKGame

@synthesize players = _players;
@synthesize scoreLimit = _scoreLimit;

#pragma mark - Public Class Methos

+ (instancetype)gameWithPlayers:(NSOrderedSet<NSString *> *)players scoreLimit:(NSUInteger)scoreLimit {
    
    return [[self alloc] initWithPlayers:players scoreLimit:scoreLimit];
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [self initWithPlayers:[[NSOrderedSet<NSString *> alloc] init] scoreLimit:100];
    
    return self;
    
}

- (NSString *)description {
    
    return self.rounds.description;
    
}

- (NSUInteger)hash {
    
    return self.players.hash ^ self.rounds.hash ^ @(self.scoreLimit).hash;
    
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        
        return YES;
        
    } else if (![object isKindOfClass:[FKGame class]]) {
        
        return NO;
        
    }
    
    return [self isEqualToGame:(FKGame *)object];
    
}

#pragma mark - Property Access Methods

- (NSUInteger)numberOfRounds {
    
    return self.rounds.count;
    
}

- (NSOrderedSet<NSString *> *)alivePlayers {
    
    NSArray<NSString *> *players = @[];
    
    for (NSString *player in self.players) {
        
        NSNumber *score = self[player];
        
        if (score.unsignedIntegerValue < self.scoreLimit) {
            
            players = [players arrayByAddingObject:player];
            
        }
        
    }
    
    return [NSOrderedSet<NSString *> orderedSetWithArray:players];
    
}

- (BOOL)isFinished {
    
    return self.alivePlayers.count == 1;
    
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    
    return YES;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.players forKey:NSStringFromSelector(@selector(players))];
    [aCoder encodeObject:@(self.scoreLimit) forKey:NSStringFromSelector(@selector(scoreLimit))];
    [aCoder encodeObject:self.rounds forKey:NSStringFromSelector(@selector(rounds))];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSOrderedSet<NSString *> *players = [aDecoder decodeObjectOfClass:[NSOrderedSet<NSString *> class] forKey:NSStringFromSelector(@selector(players))];
    NSUInteger scoreLimit = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(scoreLimit))]).unsignedIntegerValue;
    
    self = [self initWithPlayers:players scoreLimit:scoreLimit];
    
    if (self) {
        
        self->_rounds = (NSMutableArray<FKRoundScore *> *)[aDecoder decodeObjectOfClass:[NSMutableArray<FKRoundScore *> class] forKey:NSStringFromSelector(@selector(rounds))];
        
    }
    
    return self;
    
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    FKGame *copy = [[[self class] allocWithZone:zone] init];
    copy->_players = [self.players copyWithZone:zone];
    copy->_scoreLimit = self.scoreLimit;
    copy->_rounds = [self.rounds copyWithZone:zone];
    
    return copy;
    
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {

    return [self.rounds countByEnumeratingWithState:state
                                            objects:buffer
                                              count:len];
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithPlayers:(NSOrderedSet<NSString *> *)players scoreLimit:(NSUInteger)scoreLimit {
    
    if (players.count < 2) {
        
        [NSException raise:FKGameInvalidPlayerCountException format:@"A game must contain at minimum 2 playesr"];
        
        return nil;
        
    }
    
    if (scoreLimit < 50) {
        
        [NSException raise:FKGameInvalidScoreLimitException format:@"Score limit must be 50 or more"];
        
        return nil;
        
    }
    
    self = [super init];
    
    if (self) {
        
        self.players = players;
        self.scoreLimit = scoreLimit;
        self.rounds = [[NSMutableArray<FKRoundScore *> alloc] init];
        
    }
    
    return self;
    
}

- (BOOL)isEqualToGame:(FKGame *)game {
    
    if (!game) {
        
        return NO;
        
    }
    
    BOOL equalPlayers = [self.players isEqualToOrderedSet:game.players];
    BOOL equalRounds = [self.rounds isEqualToArray:game.rounds];
    BOOL equalScoreLimits = self.scoreLimit == game.scoreLimit;
    
    return equalPlayers && equalRounds && equalScoreLimits;
    
}

- (void)addRoundScore:(FKRoundScore *)roundScore {
    
    if (!roundScore.complete) {
        
        [NSException raise:FKGameIncompleteRoundScoreException format:@"%@ does not contain a score for every player", roundScore];
        
        return;
    }
    
    if (![self.alivePlayers isEqualToOrderedSet:roundScore.players]) {
        
        [NSException raise:FKGameInvalidPlayerException format:@"%@ contains invalid players", roundScore];
        
        return;
        
    }
    
    [self.rounds addObject:roundScore];
    
}

- (NSNumber *)totalScoreForPlayer:(NSString *)player {

    if (![self.players containsObject:player]) {
        
        [NSException raise:FKGameInvalidPlayerException format:@"Game does not container player %@", player];
        
        return nil;
        
    }
    
    NSUInteger total = 0;

    for (FKRoundScore *score in self) {
        
        total += [score scoreForPlayer:player].unsignedIntegerValue;
        
    }
    
    return @(total);

}

- (FKRoundScore *)roundScoreAtIndex:(NSUInteger)index {
    
    return self.rounds[index];
    
}

- (NSNumber *)objectForKeyedSubscript:(NSString *)key {
    
    return [self totalScoreForPlayer:key];
    
}

- (FKRoundScore *)objectAtIndexedSubscript:(NSUInteger)idx {
    
    return [self roundScoreAtIndex:idx];
    
}

@end
