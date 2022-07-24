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

import AppFoundation
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

                Divider()

                List {

                    ForEach(game.rounds.indices, id: \.self) { index in

                        Button(action: { editingRound = RoundAndIndex(round: game[index], id: index) }) {
                            ScoreRow(signpost: game.startingPlayer(atIndex: index).signpost(for: game.allPlayers),
                                     round: game.rounds[index],
                                     players: game.allPlayers,
                                     activePlayers: game.activePlayers)

                        }

                    }
                    .onDelete(perform: deleteItems(offsets:))
                    .scoreCardRow()

                    if !game.isComplete {
                        Button(action: showAddRound) {
                            AddRow(signpost: game.startingPlayer(atIndex: game.rounds.count).signpost(for: game.allPlayers))
                                .sheet(isPresented: $showingAddRound) {
                                    RoundEditor(game: $game)
                                }
                        }
                        .scoreCardRow()
                    }

                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .listRowSeparator(.hidden)

                }
                .listStyle(PlainListStyle())

                Divider()

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
        .sheet(item: $editingRound) { roundAndIndex in
            RoundEditor(game: $game, previousIndex: roundAndIndex.id)
        }
        .sheet(isPresented: $showingAddRound) {
            RoundEditor(game: $game)
        }
        .alert("Cannot delete this round", isPresented: $roundAlert) {
            Button("OK") { roundAlert = false }
        } message: {
            Text("Please delete newer rounds first")
        }
        .onChange(of: game, perform: persist(game:))
    }

    // MARK: - Private

    private struct RoundAndIndex: Identifiable {
        let round: Round
        let id: Int
    }

    @State
    private var game: Game

    @State
    private var showingAddRound = false

    @State
    private var editingRound: RoundAndIndex?

    @State
    private var roundAlert: Bool = false

    private var totalScores: [Int] {
        game.allPlayers.map { game.totalScore(forPlayer: $0) }
    }

    private func showAddRound() {
        showingAddRound = true
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            if game.canDeleteRound(atIndex: index) {
                game.deleteRound(atIndex: index)
            } else {
                roundAlert = true
            }
        }
    }

    private func close() {
        withAnimation {
            try! gameManager.deactivateGame()
        }
    }

    private func persist(game: Game) {
        try! gameManager.updateGame(game)
        try! gameManager.save()
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

private extension View {

    func scoreCardRow() -> some View {
        padding(.vertical, 0)
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .frame(maxWidth: .infinity, maxHeight: 44)
    }

}
