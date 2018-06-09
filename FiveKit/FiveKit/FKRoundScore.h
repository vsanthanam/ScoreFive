//
//  FKRoundScore.h
//  FiveKit
//
//  Created by Varun Santhanam on 6/3/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

extern NSString * const FKRoundScoreInvalidScoreException;
extern NSString * const FKRoundScoreInvalidPlayerException;

@interface FKRoundScore : NSObject<NSSecureCoding, NSCopying>

@property (NS_NONATOMIC_IOSONLY, copy, readonly) NSOrderedSet<NSString *> *players;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isComplete) BOOL complete;

+ (nullable instancetype)roundScoreWithPlayers:(nonnull NSOrderedSet<NSString *> *)players;

- (nullable instancetype)initWithPlayers:(nonnull NSOrderedSet<NSString *> *)players NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToRoundScore:(nullable FKRoundScore *)roundScore;

- (nullable NSNumber *)scoreForPlayer:(nonnull NSString *)player;
- (void)setScore:(nonnull NSNumber *)score forPlayer:(nonnull NSString *)player;
- (void)removeScoreForPlayer:(nonnull NSString *)player;

- (void)setObject:(nonnull NSNumber *)obj forKeyedSubscript:(nonnull NSString *)key;
- (nullable NSNumber *)objectForKeyedSubscript:(nonnull NSString *)key;

@end
