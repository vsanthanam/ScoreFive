//
//  FKGame.m
//  FiveKit
//
//  Created by Varun Santhanam on 6/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "FKGame.h"

NSString * const FKGameIncompleteRoundScoreException = @"kFKGameIncompleteRoundScoreException";

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
    
    self = [self initWithPlayers:[[NSOrderedSet<NSString *> alloc] init] scoreLimit:kWinningScore * 2];
    
    return self;
    
}

- (NSString *)description {
    
    return self.rounds.description;
    
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

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    
    return YES;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [self init];
    
    return self;
    
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    return nil;
    
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {

    return [self.rounds countByEnumeratingWithState:state
                                            objects:buffer
                                              count:len];
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithPlayers:(NSOrderedSet<NSString *> *)players scoreLimit:(NSUInteger)scoreLimit {
    
    self = [super init];
    
    if (self) {
        
        self.players = players;
        self.scoreLimit = scoreLimit;
        self.rounds = [[NSMutableArray<FKRoundScore *> alloc] init];
        
    }
    
    return self;
    
}

- (void)addRoundScore:(FKRoundScore *)roundScore {
    
    if (roundScore.complete && [self.alivePlayers isEqualToOrderedSet:roundScore.players]) {
        
        [self.rounds addObject:roundScore];
        
    } else {
        
        [NSException raise:FKGameIncompleteRoundScoreException format:@"%@ is an incomplete or invalid round", roundScore];
        
    }
    
}

- (NSNumber *)totalScoreForPlayer:(NSString *)player {

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
