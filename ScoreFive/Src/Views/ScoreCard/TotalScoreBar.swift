//
//  TotalScoreRow.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/22.
//

import Five
import SwiftUI

struct TotalScoreBar: View {

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
                        .opacity(opacity(for: player))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 12)
        .background(
            Color(uiColor: UIColor.systemBackground) // any non-transparent background
                .shadow(radius: 10, x: 0, y: 0)
                .mask(Rectangle().padding(.top, -20)) /// here!
        )
    }

    // MARK: - Private

    private func opacity(for player: Game.Player) -> Double {
        game.activePlayers.contains(player) ? 1.0 : 0.5
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
