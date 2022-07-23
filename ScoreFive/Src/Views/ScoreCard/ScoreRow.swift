//
//  ScoreRow.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/16/22.
//

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
        } else if score == max {
            return .red
        } else {
            return .init(uiColor: .label)
        }
    }

    private func opacity(for player: Game.Player) -> Double {
        activePlayers.contains(player) ? 1.0 : 0.5
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
