//
//  NewGame.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/10/22.
//

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
        .init(get: {
            scoreLimit.description
        }, set: { newValue in
            scoreLimit = Int(newValue) ?? 0
        })
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
