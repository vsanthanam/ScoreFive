//
//  FKRoundScore.m
//  FiveKit
//
//  Created by Varun Santhanam on 6/3/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "FKRoundScore.h"

NSString * const FKRoundScoreInvalidScoreException = @"kFKRoundScoreInvalidScoreException";
NSString * const FKRoundScoreInvalidPlayerException = @"kFKRoundScoreInvalidPlayerException";

@interface FKRoundScore ()

@property (NS_NONATOMIC_IOSONLY, strong) NSMutableDictionary<NSString *, NSNumber *> *scores;
@property (NS_NONATOMIC_IOSONLY, copy) NSOrderedSet<NSString *> *players;

@end

@implementation FKRoundScore

@synthesize scores = _scores;
@synthesize players = _players;

#pragma mark - Public Class Methods

+ (instancetype)roundScoreWithPlayers:(NSOrderedSet<NSString *> *)players {
    
    return [[self alloc] initWithPlayers:players];
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [self initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithArray:@[]]];
    
    return self;
}

- (NSString *)description {
    
    return self.scores.description;
    
}

- (NSUInteger)hash {
    
    return self.scores.hash ^ self.players.hash;
    
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        
        return YES;
        
    } else if (![object isKindOfClass:[FKRoundScore class]]) {
        
        return NO;
        
    }
    
    return [self isEqualToRoundScore:(FKRoundScore *)object];
    
}

#pragma mark - Property Access Methods

- (BOOL)isComplete {
    
    if (self.scores.allValues.count != self.players.count) {
        
        return false;
        
    }
    
    if (![self.scores.allValues containsObject:@0]) {
        
        return false;
        
    }
    
    NSSet<NSNumber *> *set = [NSSet<NSNumber *> setWithArray:self.scores.allValues];
    
    return set.count > 1;
    
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    
    return YES;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.players forKey:NSStringFromSelector(@selector(players))];
    [aCoder encodeObject:self.scores forKey:NSStringFromSelector(@selector(scores))];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSOrderedSet<NSString *> *players = (NSOrderedSet<NSString *> *)[aDecoder decodeObjectOfClass:[NSOrderedSet<NSString *> class] forKey:NSStringFromSelector(@selector(players))];
    NSMutableDictionary<NSString *, NSNumber *> *scores = (NSMutableDictionary<NSString *, NSNumber *> *)[aDecoder decodeObjectOfClass:[NSMutableDictionary<NSString *, NSNumber *> class] forKey:NSStringFromSelector(@selector(scores))];
    
    self = [self initWithPlayers:players];
    
    if (self) {
        
        self.scores = scores;
        
    }
    
    return self;
    
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    FKRoundScore *copy = [[[self class] allocWithZone:zone] init];
    
    copy->_players = [self.players copyWithZone:zone];
    copy->_scores = [self.scores copyWithZone:zone];
    
    return copy;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithPlayers:(NSOrderedSet<NSString *> *)players {
    
    self = [super init];
    
    if (self) {
        
        self.players = players;
        self.scores = [[NSMutableDictionary<NSString *, NSNumber *> alloc] init];
        
    }
    
    return self;
    
}

- (BOOL)isEqualToRoundScore:(FKRoundScore *)roundScore {
    
    if (!roundScore) {
        
        return NO;
        
    }
    
    BOOL equalPlayers = [self.players isEqualToOrderedSet:roundScore.players];
    BOOL equalScores = [self.scores isEqualToDictionary:roundScore.scores];
    
    return equalPlayers && equalScores;
    
}

- (NSNumber *)scoreForPlayer:(NSString *)player {
    
    if (![self.players containsObject:player]) {
        
        [NSException raise:FKRoundScoreInvalidPlayerException format:@"Round does not contain player %@", player];
        
        return nil;
        
    }
    
    return self.scores[player];
    
}

- (void)setScore:(NSNumber *)score forPlayer:(NSString *)player {
    
    if (![self.players containsObject:player]) {
        
        [NSException raise:FKRoundScoreInvalidPlayerException format:@"Round does not contain player %@", player];
        
        return;
        
    }
    
    if (!score) {
        
        [self.scores removeObjectForKey:player];
        
        return;
        
    }
    
    if (score.integerValue < 0|| score.integerValue > 50) {
        
        [NSException raise:FKRoundScoreInvalidScoreException format:@"%@ is an invalid score", score];
        
        return;
        
    }
    
    if (score) {
        
         self.scores[player] = score;
        
    }
    
}

- (void)removeScoreForPlayer:(NSString *)player {
    
    if (![self.players containsObject:player]) {
        
        [NSException raise:FKRoundScoreInvalidPlayerException format:@"Round does not container player %@", player];
        
        return;
        
    }
    
    [self.scores removeObjectForKey:player];
    
}

- (NSNumber *)objectForKeyedSubscript:(NSString *)key {
    
    return [self scoreForPlayer:key];
    
}

- (void)setObject:(NSNumber *)obj forKeyedSubscript:(NSString *)key {
    
    [self setScore:obj forPlayer:key];
    
}

@end
