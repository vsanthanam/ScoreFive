// Five
// Game.swift
//
// MIT License
//
// Copyright (c) 2021 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import OrderedCollections

/// A game of Five
public struct Game: Sendable, Equatable, Hashable, Codable, CustomStringConvertible, Identifiable {

    // MARK: - Initialzer

    /// Create a new game
    /// - Parameters:
    ///   - players: The players in the came
    ///   - scoreLimit: The score limit used to end the game.
    /// - Note: The score limit must be greater than or equal to 50
    public init(players: [Player],
                scoreLimit: TotalScore = 250) {
        id = UUID().uuidString
        precondition(players.allSatisfy(\.isValid), "Player names must contain at least 1 character!")
        precondition(Set(players).count == players.count, "Player names must be unique!")
        precondition(scoreLimit >= 50, "Score limit must be greater than or equal to 50!")
        precondition(players.count >= 2, "Game must contain at least two players!")
        orderedPlayers = .init(players)
        self.scoreLimit = scoreLimit
    }

    // MARK: - API

    /// A player
    public typealias Player = String

    /// A player's total score
    public typealias TotalScore = Int

    /// Sorting options for a set of players
    public enum PlayerSort {

        /// The order in which the players play
        case playingOrder

        /// Winning players, then losing players
        case winningToLosing

        /// Losing players, then winning players
        case losingToWinning
    }

    /// All the rounds in the game
    public private(set) var rounds = [Round]()

    /// The score limit used to eliminate players from the game
    public let scoreLimit: TotalScore

    /// Whether or not the game is complet
    public var isComplete: Bool {
        activePlayers.count == 1
    }

    /// The results of the game
    /// - Throws: `Error.incompleteGame` if the game is incomplete.
    public var result: Game.Result {
        get throws {
            guard isComplete else {
                throw Error.incompleteGame
            }
            return .init(game: self, rounds: rounds)
        }
    }

    /// All players in the game
    public var allPlayers: OrderedSet<Player> {
        allPlayers(withSort: .playingOrder)
    }

    /// Players which are still in the game
    public var activePlayers: OrderedSet<Player> {
        activePlayers(withSort: .playingOrder)
    }

    /// The game's current winners
    public var winners: Set<Player> {
        let winner = activePlayers(withSort: .winningToLosing).first!
        let winningScore = totalScore(forPlayer: winner)
        return .init(activePlayers.filter { totalScore(forPlayer: $0) == winningScore })
    }

    /// The game's current losers
    public var losers: Set<Player> {
        let loser = allPlayers(withSort: .losingToWinning).first!
        let losingScore = totalScore(forPlayer: loser)
        return .init(allPlayers.filter { player in totalScore(forPlayer: player) == losingScore })
    }

    /// The game's current losers who have yet to be eliminated
    public var activeLosers: Set<Player> {
        let loser = activePlayers(withSort: .losingToWinning).first!
        let losingScore = totalScore(forPlayer: loser)
        return .init(activePlayers.filter { player in totalScore(forPlayer: player) == losingScore })
    }

    /// The total score for a given player
    /// - Parameter player: The player
    /// - Returns: The player's total score
    public func totalScore(forPlayer player: Player) -> TotalScore {
        rounds
            .filter { $0.players.contains(player) }
            .map { $0[player] }
            .compactMap { $0 }
            .reduce(0, +)
    }

    /// All players in the game
    /// - Parameter sort: The sorting order of the players
    /// - Returns: The players in the game, including players which may have already been eliminated
    public func allPlayers(withSort sort: PlayerSort) -> OrderedSet<Player> {
        switch sort {
        case .playingOrder:
            return orderedPlayers
        case .winningToLosing:
            return OrderedSet(allPlayers
                .sorted { lhs, rhs in
                    totalScore(forPlayer: lhs) < totalScore(forPlayer: rhs)
                })
        case .losingToWinning:
            return OrderedSet(allPlayers
                .sorted { lhs, rhs in
                    totalScore(forPlayer: lhs) > totalScore(forPlayer: rhs)
                })
        }
    }

    /// Players which are still in the game
    /// - Parameter sort: The sorting order of the players
    /// - Returns: The players in the the game which haven't yet been eliminated
    public func activePlayers(withSort sort: PlayerSort) -> OrderedSet<Player> {
        switch sort {
        case .playingOrder:
            return OrderedSet(orderedPlayers.filter { totalScore(forPlayer: $0) < scoreLimit })
        case .winningToLosing:
            return OrderedSet(activePlayers
                .sorted { lhs, rhs in
                    totalScore(forPlayer: lhs) < totalScore(forPlayer: rhs)
                })
        case .losingToWinning:
            return OrderedSet(activePlayers
                .sorted { lhs, rhs in
                    totalScore(forPlayer: lhs) > totalScore(forPlayer: rhs)
                })
        }
    }

    /// The player that will play first in a given round
    /// - Parameter index: The index of the round
    /// - Returns: The player
    public func startingPlayer(atIndex index: Int) -> Game.Player {
        if index == 0 {
            return allPlayers[index % allPlayers.count]
        } else {
            let alivePlayers = withFirst(n: index).activePlayers
            if alivePlayers == allPlayers {
                return allPlayers[index % allPlayers.count]
            } else {
                var player = startingPlayer(atIndex: index - 1)
                var playerIndex = allPlayers.firstIndex(of: player)!
                playerIndex += 1
                if playerIndex > allPlayers.count - 1 {
                    playerIndex = 0
                }
                player = allPlayers[playerIndex]
                while !alivePlayers.contains(player) {
                    playerIndex += 1
                    if playerIndex > allPlayers.count - 1 {
                        playerIndex = 0
                    }
                    player = allPlayers[playerIndex]
                }
                return player
            }
        }
    }

    /// Create a new round for the game
    /// - Returns: The new round, without any scores
    public func newRound() -> Round {
        .init(players: activePlayers(withSort: .playingOrder))
    }

    /// Add a new round
    /// - Parameter scoreBuilder: A function used to assign scores
    /// - Returns: The round
    public func newRound(withScores scoreBuilder: (Player) -> Round.Score) -> Round {
        var dict = OrderedDictionary<Player, Round.Score>()
        for player in activePlayers {
            let score = scoreBuilder(player)
            dict[player] = score
        }
        return .init(scores: dict)
    }

    /// Retrieve the round at a given index
    /// - Parameter index: The index
    /// - Returns: The round at the provided index
    public func round(atIndex index: Int) -> Round {
        precondition(index < rounds.count, "Invalid Index \(index)!")
        return rounds[index]
    }

    /// Add a round to the game
    /// - Parameter round: The round to add to the game
    public mutating func addRound(_ round: Round) {
        guard round.isComplete else {
            fatalError("Round is incomplete!")
        }
        guard round.players == activePlayers(withSort: .playingOrder) else {
            fatalError("Round doesn't have scores for required players")
        }
        rounds.append(round)
    }

    /// Create a new game with an additional round
    /// - Parameter round: The round to add to this game
    /// - Returns: The new game
    public func withRound(_ round: Round) -> Game {
        var copy = self
        copy.id = UUID().uuidString
        copy.addRound(round)
        return copy
    }

    /// Whether or not a round at a given index can be deleted
    /// - Parameter index: The index you wish to delete
    /// - Returns: `true` if the index can be deleted, otherwise `false`
    public func canDeleteRound(atIndex index: Int) -> Bool {
        precondition(index < rounds.count, "Invalid index \(index)!")
        guard index != rounds.count - 1 else {
            return true
        }
        var copy = self
        copy.rounds.remove(at: index)
        return copy.activePlayers == activePlayers
    }

    /// Remove a round at a provided index
    /// - Parameter index: The index containing the round you wish to remove
    public mutating func deleteRound(atIndex index: Int) {
        guard canDeleteRound(atIndex: index) else {
            fatalError("Cannot remove round at index \(index)! Game would change impossibly. Remove subsequent rounds first.")
        }
        rounds.remove(at: index)
    }

    /// Create a game without a round at given index
    /// - Parameter index: The index containing the round that the new game will not contain
    /// - Returns: The new game
    public func withoutRound(atIndex index: Int) -> Game {
        var copy = self
        copy.id = UUID().uuidString
        copy.deleteRound(atIndex: index)
        return copy
    }

    /// Whether or not you can replace a round at a provided index with a new round
    /// - Parameters:
    ///   - index: The index you wish to replace
    ///   - newRound: The new round to use in the provided index, in place of the existing round
    /// - Returns: `true` if the replacement is possible, otherwise false
    public func canReplaceRound(atIndex index: Int, with newRound: Round) -> Bool {
        precondition(index < rounds.count, "Invalid index \(index)!")
        let prev = rounds[index]
        guard prev.players == newRound.players else {
            return false
        }
        var copy = self
        copy.rounds[index] = newRound
        guard copy.activePlayers == activePlayers || index == rounds.count - 1 else {
            return false
        }
        return true
    }

    /// Replace a round at given index with a new round
    /// - Parameters:
    ///   - index: The index you wish to replace
    ///   - newRound: The new round to use in lace of the existing round
    public mutating func replaceRound(atIndex index: Int, with newRound: Round) {
        guard canReplaceRound(atIndex: index, with: newRound) else {
            fatalError("Cannot replace round at index \(index) with provided replacements \(newRound)! ")
        }
        rounds[index] = newRound
    }

    /// Create a game by replacing a round at a provided index with a new round
    /// - Parameters:
    ///   - index: The index you wish to replace
    ///   - newRound: The new round to use in place of the existing round at the provided index
    /// - Returns: The new game with the replaced round
    public func byReplacingRound(atIndex index: Int, with newRound: Round) -> Game {
        var copy = self
        copy.id = UUID().uuidString
        copy.replaceRound(atIndex: index, with: newRound)
        return copy
    }

    /// Create a game with the first n rounds of this game
    /// - Parameter n: The first
    /// - Returns: The game
    public func withFirst(n: Int) -> Game {
        precondition(n >= 0, "Invalid n \(n)!")
        var game = Game(players: .init(orderedPlayers), scoreLimit: scoreLimit)
        game.rounds = .init(rounds[0 ..< n])
        return game
    }

    // MARK: - Identifiable

    public private(set) var id: String

    // MARK: - Subscript

    public subscript(player: Player) -> TotalScore {
        totalScore(forPlayer: player)
    }

    public subscript(index: Int) -> Round {
        round(atIndex: index)
    }

    // MARK: - CustomStringConvertible

    public var description: String { rounds.description }

    // MARK: - Private

    private let orderedPlayers: OrderedSet<Player>

    private enum Error: Swift.Error {
        case incompleteGame
    }

}

extension OrderedSet: @unchecked Sendable where Element: Sendable {}
extension OrderedDictionary: @unchecked Sendable where Key: Sendable, Value: Sendable {}

private extension Game.Player {
    var isValid: Bool {
        !isEmpty
    }
}
