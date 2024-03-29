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

struct ScoreCard: View {

    // MARK: - Initializers

    init(game: Game) {
        _game = .init(initialValue: game)
    }

    // MARK: - View

    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                VStack(spacing: 0) {
                    Divider()
                    PlayerBar(players: game.allPlayers,
                              activePlayers: game.activePlayers)
                        .scoreCardRow()
                    Divider()
                    List {
                        ForEach(game.rounds, content: makeRound)
                            .onDelete(perform: deleteItems)

                        if !game.isComplete {
                            Button(action: showAddRound) {
                                AddRow(signpost: signpost(for: game.rounds.count))
                            }
                            .scoreCardRow()
                            .sheet(isPresented: $showingAddRound) {
                                RoundEditor(game: $game)
                            }
                        }
                        Spacer()
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    Divider()
                        .padding(.init(top: 0, leading: 48, bottom: 0, trailing: 0))
                    TotalScoreBar(game: $game)
                        .scoreCardRow()
                }
                Rectangle()
                    .fill(Color.tintColor)
                    .frame(maxWidth: 0.5, maxHeight: .infinity)
                    .padding(.init(top: 0, leading: 48, bottom: 0, trailing: 0))
                    .ignoresSafeArea(.all, edges: [.bottom])
                    .opacity(0.7)
            }
            .navigationTitle("Score Card")
            .navigationBarTitleDisplayMode(.inline)
            .closeButton(.trailing, action: close)
        }
        .sheet(item: $editingRound) { roundAndIndex in
            RoundEditor(game: $game, previousIndex: roundAndIndex.index)
        }
        .sheet(isPresented: $showingAddRound) {
            RoundEditor(game: $game)
        }
        .alert("Cannot delete this round", isPresented: $showingDeleteRoundAlert) {
            Button("OK") { showingDeleteRoundAlert = false }
        } message: {
            Text("Please delete newer rounds first")
        }
        .alert("Operation Failed", isPresented: $showOperationError) {
            Button("OK") { showOperationError = false }
        } message: {
            Text("Cannot perform operation")
        }
        .onChange(of: game, perform: persist(game:))
        .onAppear(perform: promptForReviewIfNeeded)
    }

    // MARK: - Private

    @State
    private var game: Game

    @State
    private var showingAddRound = false

    @State
    private var editingRound: RoundAndIndex?

    @State
    private var showingDeleteRoundAlert: Bool = false

    @State
    private var showOperationError = false

    @Environment(\.isUITest)
    private var isUITest: Bool

    @Environment(\.requestReview)
    private var requestReview: RequestReviewAction

    @EnvironmentObject
    private var gameManager: GameManager

    @AppStorage("index_by_player")
    private var indexByPlayer = true

    @AppStorage("requested_review")
    private var requestedReview = false

    @AppStorage("launch_count")
    private var launchCount = 0

    private var totalScores: [Int] {
        game.allPlayers.map(game.totalScore(forPlayer:))
    }

    @ViewBuilder
    private func makeRound(_ round: Round) -> some View {
        let index = game.rounds.firstIndex(of: round)!
        let color: Color = index % 2 == 0 ? .secondarySystemBackground : .tertiarySystemBackground
        Button(action: {
            editingRound = RoundAndIndex(round: round, index: index)
        }) {
            ScoreRow(signpost: signpost(for: index),
                     round: round,
                     players: game.allPlayers,
                     activePlayers: game.activePlayers)
        }
        .scoreCardRow(color: color)
    }

    private func signpost(for index: Int) -> String {
        indexByPlayer ? game.startingPlayer(atIndex: index).signpost(for: game.allPlayers) : (index + 1).description
    }

    private func showAddRound() {
        showingAddRound = true
    }

    private func deleteItems(offsets: IndexSet) {
        offsets
            .forEach { index in
                if game.canDeleteRound(atIndex: index) {
                    game.deleteRound(atIndex: index)
                } else {
                    showingDeleteRoundAlert = true
                }
            }
    }

    private func close() {
        do {
            try withAnimation {
                try gameManager.deactivateGame()
            }
        } catch {
            showOperationError = true
        }
    }

    private func persist(game: Game) {
        do {
            try gameManager.updateGame(game)
            try gameManager.save()
        } catch {
            showOperationError = true
        }
    }

    private func promptForReviewIfNeeded() {
        guard !isUITest else { return }
        if launchCount >= 3,
           !requestedReview {
            requestReview()
            requestedReview = true
        }
    }

    private struct RoundAndIndex: Identifiable {
        let round: Round
        let index: Int

        var id: String { round.id }
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
        round = game.newRound()
        round["Mom"] = 0
        round["Dad"] = 5
        round["God"] = 7
        round["Bro"] = 4
        game.addRound(round)
        return game
    }

    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            ScoreCard(game: testGame)
                .colorScheme(scheme)
        }
        .environmentObject(GameManager.preview)
    }
}
