//
//  LoadGame.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/16/22.
//

import SwiftUI
import CoreData

struct LoadGame: View {
    
    // MARK: - API
    
    @EnvironmentObject
    var gameManager: GameManager
    
    @Environment(\.presentationMode)
    var presentationMode
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            List(gameRecords) { game in
                Text(formatter.string(from: game.playerNames ?? []) ?? "")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                        withAnimation {
                            try! gameManager.activateGame(with: game.objectID)
                        }
                    }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("Load Game")
        }
    }
    
    // MARK: - Private
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp)])
    private var gameRecords: FetchedResults<GameRecord>
    
    private let formatter = ListFormatter()
}

struct LoadGame_Previews: PreviewProvider {
    static var previews: some View {
        LoadGame()
            .environmentObject(GameManager.preview)
    }
}
