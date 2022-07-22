//
//  ScoreCard.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/10/22.
//

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
                PlayerBar(players: Array(game.allPlayers(withSort: .playingOrder)))
                List {

                    ForEach(game.rounds.indices, id: \.self) { index in

                        Button {
                            showEditRound()
                        } label: {
                            ScoreRow(signpost: "X",
                                     players: Array(game.allPlayers(withSort: .playingOrder)),
                                     round: game.rounds[index])
                        }
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .sheet(isPresented: $showingEditRound) {
                            RoundEditor(game: $game, previousIndex: index)
                        }

                    }

                    if !game.isComplete {
                        Button(action: showAddRound) {
                            AddRow(signpost: "X")
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

                TotalScoreBar(scores: totalScores)
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
        game.allPlayers(withSort: .playingOrder).map { game.totalScore(forPlayer: $0) }
    }

    private func showAddRound() {
        showingAddRound.toggle()
    }

    private func showEditRound() {
        showingEditRound.toggle()
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
