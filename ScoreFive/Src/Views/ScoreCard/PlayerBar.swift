// ScoreFive
// PlayerBar.swift
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
