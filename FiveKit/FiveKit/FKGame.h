//
//  FKGame.h
//  FiveKit
//
//  Created by Varun Santhanam on 6/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

#import "FKRoundScore.h"

extern NSString * const FKGameIncompleteRoundScoreException;

@interface FKGame : NSObject<NSCopying, NSSecureCoding, NSFastEnumeration>

@property (NS_NONATOMIC_IOSONLY, copy, readonly, nonnull) NSOrderedSet<NSString *> *players;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) NSUInteger scoreLimit;

@property (NS_NONATOMIC_IOSONLY, readonly, nonnull) NSOrderedSet<NSString *> *alivePlayers;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger numberOfRounds;
@property (NS_NONATOMIC_IOSONLY, getter=isFinished) BOOL finished;

+ (nullable instancetype)gameWithPlayers:(nonnull NSOrderedSet<NSString *> *)players scoreLimit:(NSUInteger)scoreLimit;

- (nullable instancetype)initWithPlayers:(nonnull NSOrderedSet<NSString *> *)players scoreLimit:(NSUInteger)scoreLimit NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToGame:(nullable FKGame *)game;

- (void)addRoundScore:(nonnull FKRoundScore *)roundScore;

- (nonnull NSNumber *)totalScoreForPlayer:(nonnull NSString *)player;
- (nonnull FKRoundScore *)roundScoreAtIndex:(NSUInteger)index;

- (nonnull NSNumber *)objectForKeyedSubscript:(nonnull NSString *)key;
- (nonnull FKRoundScore *)objectAtIndexedSubscript:(NSUInteger)idx;

@end
