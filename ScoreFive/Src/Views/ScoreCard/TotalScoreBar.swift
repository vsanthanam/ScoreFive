// ScoreFive
// TotalScoreBar.swift
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
import SwiftUI

struct TotalScoreBar: View {

    // MARK: - API

    @Binding
    var game: Game

    // MARK: - View

    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text("")
            }
            .frame(width: 48)
            HStack {
                ForEach(game.allPlayers, id: \.self) { player in
                    Text(game[player].description)
                        .bold()
                        .foregroundColor(color(for: player))
                        .opacity(opacity(for: player))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 12)
    }

    // MARK: - Private

    private func color(for player: Game.Player) -> Color {
        guard game.rounds.count >= 1 else {
            return .label
        }
        if game.winners.contains(player) {
            return .green
        } else if game.activeLosers.contains(player) {
            return .red
        }
        return .label
    }

    private func opacity(for player: Game.Player) -> Double {
        game.activePlayers.contains(player) ? 1.0 : 0.3
    }
}

struct TotalScoreBar_Previews: PreviewProvider {

    static var previewGame: Game {
        var firstGame = Game(players: ["Mom", "Dad", "God", "Bro"], scoreLimit: 250)
        var round = firstGame.newRound()
        round["Mom"] = 0
        round["Dad"] = 23
        round["God"] = 35
        round["Bro"] = 11
        firstGame.addRound(round)
        return firstGame
    }

    static var previews: some View {
        TotalScoreBar(game: .constant(previewGame))
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
