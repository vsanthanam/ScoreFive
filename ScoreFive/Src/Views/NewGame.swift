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

    @Environment(\.presentationMode)
    var presentationMode

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
                        TextField("Player \(index + 1)", text: $players[index])
                            .autocapitalization(.words)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                    }
                    if canAddPlayer {
                        Button {
                            withAnimation { players.append("") }
                        } label: {
                            Text("Add Player")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                if canSaveGame {
                    Section {
                        Button {
                            withAnimation { save() }
                        } label: {
                            Text("Start Game")
                                .frame(maxWidth: .infinity)
                        }
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

    private func save() {
        let game = Game(players: players)
        let id = try! gameManager.storeNewGame(game)
        presentationMode.wrappedValue.dismiss()
        try! gameManager.activateGame(with: id)
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
        return true
    }

}

struct NewGame_Previews: PreviewProvider {
    static var previews: some View {
        NewGame()
    }
}
