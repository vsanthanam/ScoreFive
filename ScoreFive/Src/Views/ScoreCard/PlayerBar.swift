//
//  PlayerBar.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/22.
//

import Five
import SwiftUI

struct PlayerBar: View {

    var players: [Game.Player]

    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text("")
            }
            .frame(width: 48)
            HStack {
                ForEach(players, id: \.self) { player in
                    Text(player.capitalized.first?.description ?? "X")
                        .bold()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 12)
        .background(
            Color(uiColor: UIColor.systemBackground)
                .shadow(radius: 10, x: 0, y: 0)
                .mask(Rectangle().padding(.bottom, -20))
        )
    }
}

struct PlayerBar_Previews: PreviewProvider {
    static var previews: some View {
        PlayerBar(players: ["Mom", "Dad", "God", "Bro"])
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
