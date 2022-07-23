// ScoreFive
// NewGame.swift
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

struct NewGame: View {

    // MARK: - API

    @Environment(\.dismiss)
    var dismiss

    @EnvironmentObject
    var gameManager: GameManager

    // MARK: - View

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Score Limit", text: scoreLimitBining)
                        .keyboardType(.numberPad)
                }
                Section {
                    ForEach(players.indices, id: \.self) { index in
                        PlayerTextField(index: index, player: $players[index])
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            players.remove(at: index)
                        }
                    }
                    .deleteDisabled(players.count <= 2)
                    if canAddPlayer {
                        FormButton(text: "Add Player", action: addPlayer)
                    }
                }
                if canSaveGame {
                    Section {
                        FormButton(text: "Start Game", action: save)
                    }
                }
            }
            .navigationTitle("New Game")
        }
    }

    // MARK: - Private

    @State
    private var players: [String] = ["", ""]

    @State
    private var scoreLimit = 250

    private var scoreLimitBining: Binding<String> {
        .init {
            scoreLimit.description
        } set: { newValue in
            scoreLimit = Int(newValue) ?? 0
        }
    }

    private var canAddPlayer: Bool {
        players.count < 8
    }

    private var canSaveGame: Bool {
        let set = OrderedSet<String>(players)
        guard set.count == players.count else {
            return false
        }
        guard set.count >= 2, set.count <= 8 else {
            return false
        }
        guard set.allSatisfy({ !$0.isEmpty }) else {
            return false
        }
        guard scoreLimit >= 50, scoreLimit <= 250 else {
            return false
        }
        return true
    }

    private func save() {
        withAnimation {
            let game = Game(players: players, scoreLimit: scoreLimit)
            let record = try! gameManager.storeNewGame(game)
            dismiss()
            try! gameManager.activateGame(with: record)
            try! gameManager.save()
        }
    }

    private func addPlayer() {
        withAnimation { players.append("") }
    }

}

struct NewGame_Previews: PreviewProvider {
    static var previews: some View {
        NewGame()
    }
}
