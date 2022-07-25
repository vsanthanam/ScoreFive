// ScoreFive
// RoundEditor.swift
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

struct RoundEditor: View {

    // MARK: - Initializers

    init(game: Binding<Game>, previousIndex: Int? = nil) {
        self.previousIndex = previousIndex
        _game = game
        if let previousIndex = previousIndex {
            _round = .init(initialValue: InProgressRound(game.wrappedValue[previousIndex]))
        } else {
            _round = .init(initialValue: InProgressRound(game.wrappedValue.newRound()))
        }
    }

    // MARK: - API

    @Binding
    var game: Game

    // MARK: - View

    var body: some View {
        NavigationView {
            Form {
                Section {
                    ForEach(round.players, id: \.self) { player in
                        TextField(player, text: binding(for: player))
                            .keyboardType(.numberPad)
                    }
                } footer: {
                    if let status = round.statusMessage {
                        Text(status)
                    } else {
                        EmptyView()
                    }
                }
                Section {
                    FormButton(text: "Done", action: save)
                        .disabled(!round.isValid)
                }
                .multilineTextAlignment(.center)
            }
            .navigationTitle("Enter Scores")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text("You cannot change a round this much!")
            }
        }
    }

    // MARK: - Private

    private struct InProgressRound {

        init(_ round: Round) {
            players = Array(round.players)
            scores = [:]
            for player in players {
                if let score = round.score(forPlayer: player) {
                    scores[player] = String(score)
                } else {
                    scores[player] = ""
                }
            }
        }

        var statusMessage: String? {
            guard !isValid else {
                return nil
            }
            let scores = scores.values.map(Int.init).compactMap { $0 }
            if !scores.allSatisfy({ $0 >= 0 && $0 <= 50 }) {
                return "All scores must be between 0 and 50"
            }
            if scores.filter({ $0 == 0 }).isEmpty, scores.count == players.count {
                return "Round must contain at least one winner"
            }
            if scores.filter({ $0 == 0 }).count == players.count, scores.count == players.count {
                return "Round must contain at at least one loser"
            }
            return nil
        }

        var isComplete: Bool {
            let scores = scores.values.map(Int.init).compactMap { $0 }
            guard scores.count == players.count else {
                return false
            }
            return true
        }

        var isValid: Bool {
            let scores = scores.values.map(Int.init).compactMap { $0 }
            guard scores.count == players.count else {
                return false
            }
            guard scores.filter({ $0 == 0 }).count >= 1 else {
                return false
            }
            guard scores.filter({ $0 == 0 }).count < players.count else {
                return false
            }
            guard scores.allSatisfy({ $0 >= 0 && $0 <= 50 }) else {
                return false
            }
            return true
        }

        let players: [Game.Player]

        var scores: [Game.Player: String]

        func buildRound() -> Round {
            var round = Round(players: OrderedSet(players))
            for player in players {
                round[player] = Round.Score(scores[player] ?? "")
            }
            return round
        }
    }

    private let previousIndex: Int?

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @EnvironmentObject
    private var gameManager: GameManager

    @State
    private var round: InProgressRound

    @State
    private var showingAlert: Bool = false

    private func save() {
        if let previousIndex = previousIndex {
            let proposed = round.buildRound()
            if game.canReplaceRound(atIndex: previousIndex, with: proposed) {
                game.replaceRound(atIndex: previousIndex, with: proposed)
                dismiss()
            } else {
                showingAlert = true
            }
        } else {
            game.addRound(round.buildRound())
            dismiss()
        }
    }

    private func binding(for player: Game.Player) -> Binding<String> {
        .init(get: {
            round.scores[player] ?? ""
        }, set: { score in
            withAnimation {
                round.scores[player] = score
            }
        })
    }

}

struct RoundEditor_Previews: PreviewProvider {

    static var testGame: Game {
        var game = Game(players: ["Mom", "Dad", "God", "Bro"])
        var round = game.newRound()
        round["Mom"] = 23
        round["Dad"] = 11
        round["God"] = 50
        round["Bro"] = 0
        game.addRound(round)
        return game
    }

    static var previews: some View {
        RoundEditor(game: .constant(testGame), previousIndex: 0)
    }
}