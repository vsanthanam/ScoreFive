// ScoreFive
// MainMenu.swift
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

import CoreData
import Five
import SwiftUI

struct MainMenu: View {

    // MARK: - Initializers

    init(shouldAutoLaunch: Bool = false) {
        self.shouldAutoLaunch = shouldAutoLaunch
    }

    // MARK: - API

    @EnvironmentObject
    var gameManager: GameManager

    // MARK: - View

    var body: some View {
        if let identifier = gameManager.activeGameRecord {

            ScoreCard(game: try! gameManager.game(for: identifier))

        } else {

            VStack {

                Button(action: showNewGame) {
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

                if !gameRecords.isEmpty {
                    Button(action: showLoadGame) {
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

                Button(action: showSettings) {
                    Text("Settings")
                        .frame(width: 120)
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showingSettings) {
                    Settings()
                }

            }
            .onAppear {
                if gameRecords.isEmpty, shouldAutoLaunch {
                    showingNewGame = true
                }
            }

        }

    }

    // MARK: - Private

    private let shouldAutoLaunch: Bool

    @State
    private var showingNewGame = false

    @State
    private var showingLoadGame = false

    @State
    private var showingSettings = false

    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp)])
    private var gameRecords: FetchedResults<GameRecord>

    private func showNewGame() {
        showingNewGame = true
    }

    private func showLoadGame() {
        showingLoadGame = true
    }

    private func showSettings() {
        showingSettings = true
    }

}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
            .environmentObject(GameManager.preview)
    }
}
