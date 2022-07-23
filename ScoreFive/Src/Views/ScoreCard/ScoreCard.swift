// ScoreFive
// ScoreCard.swift
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

struct ScoreCard: View {

    // MARK: - Initializers

    init(game: Game) {
        self.game = game
    }

    // MARK: - API

    @EnvironmentObject
    var gameManager: GameManager

    // MARK: - View

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                PlayerBar(players: game.allPlayers)
                List {

                    ForEach(game.rounds.indices, id: \.self) { index in

                        Button(action: showEditRound) {
                            ScoreRow(signpost: game.startingPlayer(atIndex: index).signpost(for: game.allPlayers),
                                     round: game.rounds[index],
                                     players: game.allPlayers,
                                     activePlayers: game.activePlayers)
                        }
                        .sheet(isPresented: $showingEditRound) {
                            RoundEditor(game: $game, previousIndex: index)
                        }

                    }
                    .padding(.vertical, 8)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                    if !game.isComplete {
                        Button(action: showAddRound) {
                            AddRow(signpost: game.startingPlayer(atIndex: game.rounds.count).signpost(for: game.allPlayers))
                                .sheet(isPresented: $showingAddRound) {
                                    RoundEditor(game: $game)
                                }
                        }
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .sheet(isPresented: $showingAddRound) {
                            RoundEditor(game: $game)
                        }
                    }

                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: 24)
                        .listRowSeparator(.hidden)

                }
                .listStyle(PlainListStyle())

                TotalScoreBar(game: $game)
            }
            .navigationTitle("Score Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: close) {
                        Text("Close")
                    }
                }
            }
        }
        .onChange(of: game) { game in
            try! gameManager.updateGame(game)
            try! gameManager.save()
        }
    }

    // MARK: - Private

    @State
    private var game: Game

    @State
    private var showingAddRound = false

    @State
    private var showingEditRound = false

    private var totalScores: [Int] {
        game.allPlayers.map { game.totalScore(forPlayer: $0) }
    }

    private func showAddRound() {
        showingAddRound = true
    }

    private func showEditRound() {
        showingEditRound = true
    }

    private func close() {
        withAnimation {
            try! gameManager.deactivateGame()
        }
    }
}

struct ScoreCard_Previews: PreviewProvider {

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
        ScoreCard(game: testGame)
            .environmentObject(GameManager.preview)
    }
}

extension Game.Player {

    func signpost(for players: OrderedSet<Game.Player>) -> String {
        if contains("Player ") {
            let index = players.firstIndex(of: self)!
            return "P\(index + 1)"
        } else {
            return capitalized.first!.description
        }
    }

}
