// Five
// GameResult.swift
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

public extension Game {

    struct Result: Equatable, Hashable, Sendable, Codable {

        public struct PlayerResult: Equatable, Hashable, Sendable, Codable {

            init(player: Player,
                 wins: Int,
                 losses: Int,
                 numberOfFifties: Int,
                 bestNonZeroScore: Round.Score,
                 worstNonFiftyScore: Round.Score,
                 averageScore: Double,
                 averageNonZeroScore: Double) {
                self.player = player
                self.wins = wins
                self.losses = losses
                self.numberOfFifties = numberOfFifties
                self.bestNonZeroScore = bestNonZeroScore
                self.worstNonFiftyScore = worstNonFiftyScore
                self.averageScore = averageScore
                self.averageNonZeroScore = averageNonZeroScore
            }

            public let player: Player

            public let wins: Int

            public let losses: Int

            public let numberOfFifties: Int

            public let bestNonZeroScore: Round.Score

            public let worstNonFiftyScore: Round.Score

            public let averageScore: Double

            public let averageNonZeroScore: Double

        }

        public let averageScore: Double

        public let averageNonZeroScore: Double

        public let winner: Player

        public let losers: Set<Player>

        public let orderdPlayers: OrderedSet<Player>

        public func results(forPlayer player: Player) -> PlayerResult {
            precondition(orderdPlayers.contains(player), "Invalid player \(player)!")
            return playerResults[player]!
        }

        init(game: Game,
             rounds: [Round]) {
            precondition(game.isComplete)
            let allScores: [Round.Score] = rounds
                .reduce([]) { scores, round in
                    var next = scores
                    for player in round.players {
                        next.append(round.score(forPlayer: player))
                    }
                    return next
                }
                .compactMap { $0 }
            let scoreSum = allScores.reduce(0, +)
            averageScore = (Double)(scoreSum) / (Double)(allScores.count)
            winner = game.winners.first!
            losers = game.losers
            orderdPlayers = game.allPlayers

            let nonZeroScores = allScores.filter { $0 != 50 }
            let nonZeroScoreSum = nonZeroScores.reduce(0, +)

            averageNonZeroScore = (Double)(nonZeroScoreSum) / (Double)(nonZeroScores.count)

            var playerResults = [Player: PlayerResult]()

            for player in orderdPlayers {
                let scores = rounds
                    .filter { $0.players.contains(player) }
                    .map { $0.score(forPlayer: player) }
                    .compactMap { $0 }

                let losses = rounds
                    .filter { $0.losers.contains(player) }
                    .count

                let scoreSum = scores.reduce(0, +)
                let averageScore = (Double)(scoreSum) / (Double)(scores.count)

                let nonZeroScores = scores.filter { $0 != 50 }
                let nonZeroScoreSum = nonZeroScores.reduce(0, +)

                let averageNonZeroScore = (Double)(nonZeroScoreSum) / (Double)(nonZeroScores.count)

                let result = PlayerResult(player: player,
                                          wins: scores.filter { $0 == 0 }.count,
                                          losses: losses,
                                          numberOfFifties: scores.filter { $0 == 50 }.count,
                                          bestNonZeroScore: scores.filter { $0 != 0 }.min()!,
                                          worstNonFiftyScore: scores.filter { $0 != 50 }.max()!,
                                          averageScore: averageScore,
                                          averageNonZeroScore: averageNonZeroScore)
                playerResults[player] = result
            }

            self.playerResults = playerResults

        }

        private let playerResults: [Player: PlayerResult]
    }
}
