//
//  LoadGame.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/16/22.
//

import CoreData
import SwiftUI

struct LoadGame: View {

    init() {
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
    }

    // MARK: - API

    @EnvironmentObject
    var gameManager: GameManager

    @Environment(\.dismiss)
    var dismiss

    // MARK: - View

    var body: some View {
        NavigationView {
            List {
                ForEach(gameRecords) { record in
                    VStack(alignment: .leading) {
                        Text(formatter.string(from: record.playerNames ?? []) ?? "")
                        Text("Last updated at \(dateFormatter.string(from: record.timestamp ?? .now))")
                            .font(.caption)
                    }
                    .onTapGesture {
                        dismiss()
                        withAnimation {
                            try! gameManager.activateGame(with: record)
                        }
                    }
                }
                .onDelete(perform: deleteItems(offsets:))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !gameRecords.isEmpty {
                        EditButton()
                    } else {
                        EmptyView()
                    }
                }
            }
            .navigationTitle("Load Game")
        }
    }

    // MARK: - Private

    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp)])
    private var gameRecords: FetchedResults<GameRecord>

    private let formatter = ListFormatter()

    private let dateFormatter = DateFormatter()

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { gameRecords[$0] }.forEach(gameManager.viewContext.delete)
            try! gameManager.save()
        }
    }
}

struct LoadGame_Previews: PreviewProvider {
    static var previews: some View {
        LoadGame()
            .environmentObject(GameManager.preview)
    }
}
