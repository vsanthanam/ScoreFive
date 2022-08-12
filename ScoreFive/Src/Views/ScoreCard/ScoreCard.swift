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
import StoreKit
import SwiftUI

/// The score card view
struct ScoreCard: View {

    // MARK: - Initializers

    /// Create a `ScoreCard` view
    /// - Parameter game: The game to display in the score card.
    init(game: Game) {
        self.game = game
    }

    // MARK: - View

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                PlayerBar(players: game.allPlayers,
                          activePlayers: game.activePlayers)
                Divider()
                List {

                    ForEach(game.rounds) { round in
                        let index = game.rounds.firstIndex(of: round)!
                        let color: Color = index % 2 == 0 ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .tertiarySystemBackground)
                        Button(action: {
                            editingRound = RoundAndIndex(round: round, index: index)
                        }) {
                            ScoreRow(signpost: indexByPlayer ? game.startingPlayer(atIndex: index).signpost(for: game.allPlayers) : (index + 1).description,
                                     round: round,
                                     players: game.allPlayers,
                                     activePlayers: game.activePlayers)
                        }
                        .scoreCardRow(color: color)

                    }
                    .onDelete(perform: deleteItems(offsets:))

                    if !game.isComplete {
                        Button(action: showAddRound) {
                            AddRow(signpost: indexByPlayer ? game.startingPlayer(atIndex: game.rounds.count).signpost(for: game.allPlayers) : (game.rounds.count + 1).description)
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
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle("Score Card")
            .navigationBarTitleDisplayMode(.inline)
            .closeButton(action: close)
        }
        .sheet(item: $editingRound) { roundAndIndex in
            RoundEditor(game: $game, previousIndex: roundAndIndex.index)
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
        .onAppear(perform: promptForReviewIfNeeded)
    }

    // MARK: - Private

    private struct RoundAndIndex: Identifiable {
        let round: Round
        let index: Int

        // MARK: - Identifiable

        var id: String { round.id }
    }

    @AppStorage("index_by_player")
    private var indexByPlayer = true

    @AppStorage("requested_review")
    private var requestedReview = false

    @AppStorage("launch_count")
    private var launchCount = 0

    @EnvironmentObject
    private var gameManager: GameManager

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

    private func promptForReviewIfNeeded() {
        if launchCount >= 3,
           !requestedReview,
           let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            requestedReview = true
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

private extension View {

    func scoreCardRow(color: Color? = nil) -> some View {
        let modifier = CardRowModifier(color: color)
        return ModifiedContent(content: self, modifier: modifier)
    }

}

private struct CardRowModifier: ViewModifier {

    let color: Color?

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 0)
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .frame(maxWidth: .infinity, maxHeight: 44)
            .background(color ?? Color(uiColor: .systemBackground))
    }

}
