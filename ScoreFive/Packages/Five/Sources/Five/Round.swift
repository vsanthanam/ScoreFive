// Five
// Round.swift
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

import OrderedCollections

/// A round in a game
public struct Round: Sendable, Equatable, Hashable, Codable, CustomStringConvertible {

    // MARK: - Initializers

    /// Create a round with a given list of players
    /// - Parameter players: The players that will have scores in this round
    public init(players: OrderedSet<Game.Player>) {
        for player in players {
            scores[player] = .noScore
        }
    }

    /// Create a round with a dictionary of ordered players and scores
    /// - Parameter scores: The players and their respective scores.
    public init(scores: OrderedDictionary<Game.Player, Score>) {
        self.scores = scores

        for score in scores.values {
            precondition(score.isValid || score == .noScore, "Dictionary contains is invalid score \(score)!")
        }

        let zeroes = scores.values.filter { $0 == .zero }.count
        guard zeroes >= 1 else {
            fatalError("Round must contain at least one winner!")
        }
        guard zeroes < players.count else {
            fatalError("Round must contain at least one loser")
        }
    }

    // MARK: - API

    /// A score in a round
    public typealias Score = Int

    /// The players in this round
    public var players: OrderedSet<Game.Player> {
        .init(scores.keys)
    }

    /// Whether or not the round has a score for every player
    public var isComplete: Bool {
        scores.values.filter { $0 != .noScore }.count == players.count
    }

    public var winners: Set<Game.Player> {
        guard isComplete else { fatalError("Round is incomplete") }
        return .init(players
            .filter { player in
                score(forPlayer: player) == 0
            })
    }

    public var losers: Set<Game.Player> {
        guard isComplete else { fatalError("Round is incomplete") }
        let max = scores.values.max()!
        return .init(players
            .filter { player in
                score(forPlayer: player) == max
            })
    }

    /// Retrieve the score for a player
    /// - Parameter player: The player
    /// - Returns: The score for that player, or `nil` if that player does not yet have a score
    public func score(forPlayer player: Game.Player) -> Score? {
        precondition(players.contains(player), "Round does not contain a player named \(player)!")
        guard let score = scores[player],
              score != .noScore else {
            return nil
        }
        return score
    }

    /// Set the score for a player
    /// - Parameters:
    ///   - score: The score
    ///   - player: The player
    public mutating func setScore(_ score: Score, forPlayer player: Game.Player) {
        precondition(score.isValid, "Proposed score \(score) must be greater than or equal to zero and less than or equal to 50!")
        precondition(players.contains(player), "Round does not contain a player named \(player)!")
        scores[player] = score

        if isComplete {
            let zeroes = scores.values.filter { $0 == .zero }.count
            guard zeroes >= 1 else {
                fatalError("Round must contain at least one winner!")
            }
            guard zeroes < players.count else {
                fatalError("Round must contain at least one loser")
            }
        }
    }

    /// Create a round with an additional player + score
    /// - Parameters:
    ///   - score: The score for the player
    ///   - player: The player
    /// - Returns: The new round
    public func withScore(_ score: Score, forPlayer player: Game.Player) -> Round {
        var round = self
        round.setScore(score, forPlayer: player)
        return round
    }

    /// Remove a score for a player
    /// - Parameter player: The player
    public mutating func removeScore(forPlayer player: Game.Player) {
        precondition(players.contains(player), "Round does not contain a player named \(player)!")
        scores[player] = .noScore
    }

    /// Create a round without a for a player
    /// - Parameter player: The player
    /// - Returns: The round
    public func withoutScore(forPlayer player: Game.Player) -> Round {
        var round = self
        round.removeScore(forPlayer: player)
        return round
    }

    /// Remove all scores from the round
    public mutating func eraseScores() {
        for player in players {
            scores[player] = .noScore
        }
    }

    /// Create a round without any scores
    /// - Returns: The round without any scores
    public func withoutScores() -> Round {
        var round = self
        round.eraseScores()
        return round
    }

    // MARK: - CustomStringConvertible

    public var description: String { scores.description }

    // MARK: - Subscript

    public subscript(player: Game.Player) -> Score? {
        get {
            score(forPlayer: player)
        }
        set {
            if let score = newValue {
                setScore(score, forPlayer: player)
            } else {
                removeScore(forPlayer: player)
            }
        }
    }

    // MARK: - Private

    private var scores: OrderedDictionary<Game.Player, Score> = [:]
}

private extension Round.Score {
    var isValid: Bool {
        self >= 0 && self <= 50
    }

    static var noScore: Self { -1 }
}
