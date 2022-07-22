//
//  ScoreCard.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/10/22.
//

import SwiftUI
import Five

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
            VStack {
                List {
                    ForEach(game.rounds, id: \.self) { round in
                        ScoreRow(players: Array(game.allPlayers(withSort: .playingOrder)), round: round)
                            .sheet(isPresented: $showingAddRound) {
                                RoundEditor(game: $game, previousIndex: game.rounds.firstIndex(of: round) ?? 0)
                            }
                    }
                }
                .listStyle(PlainListStyle())
                
                Button(action: showAddRound) {
                    Text("Add Round")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                }
                .background(.tint)
                .foregroundColor(.white)
                .sheet(isPresented: $showingAddRound) {
                    RoundEditor(game: $game)
                }
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
    }
    
    // MARK: - Private
    
    @State
    private var game: Game
    
    @State
    private var showingAddRound = false
    
    private func showAddRound() {
        showingAddRound.toggle()
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
