// ScoreFive
// AppExtensions.swift
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

import Five
import Foundation

extension ScoreFive {

    @MainActor
    func checkForDemo() {
        if ProcessInfo.processInfo.arguments.contains("demo") {
            var game = Game(players: ["Mom", "Dad", "God", "Bro"], scoreLimit: 250)
            var round = game.newRound()
            round["Mom"] = 21
            round["Dad"] = 17
            round["God"] = 32
            round["Bro"] = 0
            game.addRound(round)
            round = game.newRound()
            round["Mom"] = 12
            round["Dad"] = 9
            round["God"] = 0
            round["Bro"] = 4
            game.addRound(round)
            round = game.newRound()
            round["Mom"] = 0
            round["Dad"] = 50
            round["God"] = 31
            round["Bro"] = 17
            game.addRound(round)
            let record = try! GameManager.shared.storeNewGame(game)
            try! GameManager.shared.save()
            try! GameManager.shared.activateGame(with: record)
        }
    }

}
