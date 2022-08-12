// ScoreFive
// ScoreRow.swift
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

import Collections
import Five
import SwiftUI

struct ScoreRow: View {

    // MARK: - Initializers

    init(signpost: String,
         round: Round,
         players: OrderedSet<Game.Player>,
         activePlayers: OrderedSet<Game.Player>) {
        self.signpost = signpost
        self.round = round
        self.players = Array(players)
        self.activePlayers = Array(activePlayers)
    }

    // MARK: - View

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                VStack(alignment: .center) {
                    Text(signpost)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .frame(width: 48)
                HStack {
                    ForEach(players, id: \.self) { player in
                        if round.players.contains(player), let score = round[player] {
                            Text(String(score))
                                .foregroundColor(color(for: score))
                                .opacity(opacity(for: player))
                        } else {
                            Text("")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            Spacer()
            Divider()
        }
    }

    // MARK: - Private

    private let signpost: String
    private let round: Round
    private let players: [Game.Player]
    private let activePlayers: [Game.Player]

    private var min: Round.Score? {
        round.players
            .reduce([]) { scores, player in
                scores + [round.score(forPlayer: player)]
            }
            .compactMap { $0 }
            .min()
    }

    private var max: Round.Score? {
        round.players
            .reduce([]) { scores, player in
                scores + [round.score(forPlayer: player)]
            }
            .compactMap { $0 }
            .max()
    }

    private func color(for score: Round.Score) -> Color {
        if score == min {
            return .green
        } else if score == max, players.count > 2 {
            return .red
        } else {
            return .init(uiColor: .label)
        }
    }

    private func opacity(for player: Game.Player) -> Double {
        activePlayers.contains(player) ? 1.0 : 0.3
    }
}

struct ScoreRow_Previews: PreviewProvider {
    static var round: Round {
        var round = Round(players: ["Mom", "Dad", "God", "Bro"])
        round["Mom"] = 23
        round["Dad"] = 11
        round["God"] = 50
        round["Bro"] = 0
        return round
    }

    static var previews: some View {
        ScoreRow(signpost: "X",
                 round: round,
                 players: ["Mom", "Dad", "God", "Bro"],
                 activePlayers: ["Mom", "Dad", "Bro"])
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
