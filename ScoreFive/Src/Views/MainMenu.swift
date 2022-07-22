//
//  MainMenu.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/10/22.
//

import CoreData
import Five
import SwiftUI

struct MainMenu: View {

    // MARK: - API

    @EnvironmentObject
    var gameManager: GameManager

    // MARK: - View

    var body: some View {
        if let identifier = gameManager.activeGameIdentifier {
            ScoreCard(game: try! gameManager.game(for: identifier))
        } else {

            VStack {

                Button(action: toggleNewGame) {
                    Text("New Game")
                        .frame(width: 120)
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showingNewGame) {
                    NewGame()
                        .onAppear {
                            try? gameManager.save()
                        }
                }

                Button(action: toggleLoadGame) {
                    Text("Load Game")
                        .frame(width: 120)
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showingLoadGame) {
                    LoadGame()
                        .onAppear {
                            try? gameManager.save()
                        }
                }

            }

        }

    }

    // MARK: - Private

    @State
    private var showingNewGame = false

    @State
    private var showingLoadGame = false

    private func toggleNewGame() {
        showingNewGame.toggle()
    }

    private func toggleLoadGame() {
        showingLoadGame.toggle()
    }

}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
            .environmentObject(GameManager.preview)
    }
}
