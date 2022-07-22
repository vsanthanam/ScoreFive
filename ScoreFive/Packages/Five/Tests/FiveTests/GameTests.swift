// Five
// GameTests.swift
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

@testable import Five
import XCTest

final class GameTests: XCTestCase {

    func test_game() {
        let mom = "Mom"
        let dad = "Dad"
        let god = "God"
        let bro = "Bro"
        var game = Game(players: [mom, dad, god, bro])
        XCTAssertEqual(game.totalScore(forPlayer: mom), 0)
        XCTAssertEqual(game.totalScore(forPlayer: dad), 0)
        XCTAssertEqual(game.totalScore(forPlayer: god), 0)
        XCTAssertEqual(game.totalScore(forPlayer: bro), 0)

        var round = game.newRound()
        round[mom] = 0
        round[dad] = 0
        round[god] = 50
        round[bro] = 0

        game.addRound(round)

        XCTAssertEqual(game.totalScore(forPlayer: mom), 0)
        XCTAssertEqual(game.totalScore(forPlayer: dad), 0)
        XCTAssertEqual(game.totalScore(forPlayer: god), 50)
        XCTAssertEqual(game.totalScore(forPlayer: bro), 0)

        game.addRound(round)

        XCTAssertEqual(game.totalScore(forPlayer: mom), 0)
        XCTAssertEqual(game.totalScore(forPlayer: dad), 0)
        XCTAssertEqual(game.totalScore(forPlayer: god), 100)
        XCTAssertEqual(game.totalScore(forPlayer: bro), 0)

        game.addRound(round)

        XCTAssertEqual(game.totalScore(forPlayer: mom), 0)
        XCTAssertEqual(game.totalScore(forPlayer: dad), 0)
        XCTAssertEqual(game.totalScore(forPlayer: god), 150)
        XCTAssertEqual(game.totalScore(forPlayer: bro), 0)

        XCTAssertEqual(game.withFirst(n: 0).totalScore(forPlayer: mom), 0)
        XCTAssertEqual(game.withFirst(n: 0).totalScore(forPlayer: dad), 0)
        XCTAssertEqual(game.withFirst(n: 0).totalScore(forPlayer: god), 0)
        XCTAssertEqual(game.withFirst(n: 0).totalScore(forPlayer: bro), 0)

        XCTAssertEqual(game.withFirst(n: 1).totalScore(forPlayer: mom), 0)
        XCTAssertEqual(game.withFirst(n: 1).totalScore(forPlayer: dad), 0)
        XCTAssertEqual(game.withFirst(n: 1).totalScore(forPlayer: god), 50)
        XCTAssertEqual(game.withFirst(n: 1).totalScore(forPlayer: bro), 0)

        XCTAssertEqual(game.withFirst(n: 2).totalScore(forPlayer: mom), 0)
        XCTAssertEqual(game.withFirst(n: 2).totalScore(forPlayer: dad), 0)
        XCTAssertEqual(game.withFirst(n: 2).totalScore(forPlayer: god), 100)
        XCTAssertEqual(game.withFirst(n: 3).totalScore(forPlayer: bro), 0)

        XCTAssertEqual(game.withFirst(n: 3).totalScore(forPlayer: mom), 0)
        XCTAssertEqual(game.withFirst(n: 3).totalScore(forPlayer: dad), 0)
        XCTAssertEqual(game.withFirst(n: 3).totalScore(forPlayer: god), 150)
        XCTAssertEqual(game.withFirst(n: 3).totalScore(forPlayer: bro), 0)

        game.addRound(round)

        round = game.newRound()

        round[mom] = 1
        round[dad] = 2
        round[god] = 50
        round[bro] = 0

        game.addRound(round)

        XCTAssertEqual(game.activePlayers(), [mom, dad, bro])
        XCTAssertTrue(game.winners.contains(bro))
        XCTAssertEqual(game.winners.count, 1)
        XCTAssertTrue(game.losers.contains(god))
        XCTAssertEqual(game.losers.count, 1)
        XCTAssertTrue(game.activeLosers.contains(dad))
        XCTAssertEqual(game.activeLosers.count, 1)
    }

}
