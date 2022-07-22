//
//  AddRound.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/16/22.
//

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

    @Environment(\.dismiss)
    var dismiss

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
                    Button(action: save) {
                        Text("Done")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!round.isValid)
                }
                .multilineTextAlignment(.center)
            }
            .navigationTitle("Enter Scores")
            .navigationBarTitleDisplayMode(.inline)
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

    @State
    private var round: InProgressRound

    private func save() {
        game.addRound(round.buildRound())
        dismiss()
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
