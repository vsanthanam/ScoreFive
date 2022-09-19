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

    init(game: Binding<Game>,
         previousIndex: Int? = nil) {
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
        NavigationStack {
            Form {
                Section {
                    ForEach(round.players, id: \.self) { player in
                        TextField(player, text: binding(for: player))
                            .scoreToolbar(focus: $playerFocus, player: player, players: round.players)
                            .focused($playerFocus, equals: player)
                            .keyboardType(.numberPad)
                    }
                } footer: {
                    if let status = statusMessage {
                        Text(status)
                            .foregroundColor(.red)
                    } else {
                        EmptyView()
                    }
                }
                Section {
                    Button(action: save) {
                        Text("Done")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!round.isValid)
                }
                .multilineTextAlignment(.center)
            }
            .navigationTitle(previousIndex == nil ? "Add Scores" : "Edit Scores")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.default, value: statusMessage)
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { showingAlert = false }
            } message: {
                Text("You cannot change a round this much!")
            }
            .onChange(of: playerFocus) { focus in
                statusMessage = round.statusMessage
            }
            .closeButton { dismiss() }
        }
        .interactiveDismissDisabled()
    }

    // MARK: - Private

    @FocusState
    private var playerFocus: Game.Player?

    @State
    private var statusMessage: String?

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
                showingAlert.toggle()
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

private struct ScoreToolbarModifier: ViewModifier {

    let focus: FocusState<Game.Player?>.Binding
    let player: Game.Player
    let players: [Game.Player]

    func body(content: Content) -> some View {
        content
            .introspectTextField { field in
                let toolbar = UIToolbar()
                toolbar.barStyle = .default
                let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
                let closeItem = UIBarButtonItem(systemItem: .close)
                closeItem.primaryAction = .init { _ in
                    focus.wrappedValue = nil
                }
                let doneItem = UIBarButtonItem(systemItem: .done)
                doneItem.primaryAction = .init { _ in
                    focus.wrappedValue = nil
                }
                let nextItem = UIBarButtonItem()
                nextItem.primaryAction = .init(title: "Next") { _ in
                    focus.wrappedValue = players[players.firstIndex(of: player)! + 1]
                }
                if player == players.last {
                    toolbar.setItems([spacer, doneItem], animated: false)
                } else {
                    toolbar.setItems([spacer, nextItem], animated: false)
                }
                toolbar.sizeToFit()
                toolbar.updateConstraintsIfNeeded()
                field.inputAccessoryView = toolbar
            }
    }
}

private extension View {
    func scoreToolbar(focus: FocusState<Game.Player?>.Binding, player: Game.Player, players: [Game.Player]) -> some View {
        let modifier = ScoreToolbarModifier(focus: focus, player: player, players: players)
        return ModifiedContent(content: self, modifier: modifier)
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
