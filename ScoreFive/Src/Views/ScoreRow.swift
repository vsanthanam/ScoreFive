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

    // MARK: - API

    let players: [Game.Player]

    let round: Round

    // MARK: - View

    var body: some View {
        HStack {
            ForEach(players, id: \.self) { player in
                if round.players.contains(player) {
                    Text(String(round[player] ?? 0))
                } else {
                    Text("")
                }
            }
            .frame(maxWidth: .infinity)
        }
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

        ScoreRow(players: ["Mom", "Dad", "God", "Bro"],
                 round: round)
    }
}
