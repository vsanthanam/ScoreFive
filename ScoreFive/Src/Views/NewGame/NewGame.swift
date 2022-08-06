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

    // MARK: - View

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Score Limit", text: scoreLimitBining)
                        .keyboardType(.numberPad)
                        .focused($focusedPlayerIndex, equals: -1)
                        .onSubmit {
                            focusedPlayerIndex = 0
                        }
                        .submitLabel(.next)
                }
                Section {
                    ForEach(players.indices, id: \.self) { index in
                        PlayerTextField(index: index, player: $players[index], submitLabel: (index == players.count - 1) ? .done : .next)
                            .focused($focusedPlayerIndex, equals: index)
                            .onSubmit {
                                guard let focus = focusedPlayerIndex else { return }
                                if focus == (players.count - 1) {
                                    focusedPlayerIndex = nil
                                } else {
                                    focusedPlayerIndex = focus + 1
                                }
                            }
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

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @FocusState
    private var focusedPlayerIndex: Int?

    @EnvironmentObject
    private var gameManager: GameManager

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
        let nonNil = players.filter { !$0.isEmpty }

        guard nonNil.count == Set(nonNil).count else {
            return false
        }
        guard players.count >= 2, players.count <= 8 else {
            return false
        }
        guard scoreLimit >= 50, scoreLimit <= 250 else {
            return false
        }
        return true
    }

    private func deletePlayer(at index: Int) {
        players.remove(at: index)
    }

    private func addPlayer() {
        withAnimation { players.append("") }
    }

    private func save() {
        withAnimation {
            let mappedPlayers = players
                .indices
                .map { index -> Game.Player in
                    if players[index].isEmpty {
                        return "Player \(index + 1)"
                    } else {
                        return players[index]
                    }
                }
            let game = Game(players: mappedPlayers, scoreLimit: scoreLimit)
            let record = try! gameManager.storeNewGame(game)
            dismiss()
            try! gameManager.activateGame(with: record)
            try! gameManager.save()
        }
    }

}

struct NewGame_Previews: PreviewProvider {
    static var previews: some View {
        NewGame()
    }
}
