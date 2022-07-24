// ScoreFive
// LoadGame.swift
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
import SwiftUI

struct LoadGame: View {

    init() {
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
    }

    // MARK: - API

    // MARK: - View

    var body: some View {
        NavigationView {
            List {
                ForEach(gameRecords) { record in
                    Button {
                        openGame(withRecord: record)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(formatter.string(from: record.playerNames ?? []) ?? "")
                            Text("Last updated at \(dateFormatter.string(from: record.timestamp ?? .now))")
                                .font(.caption)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: deleteItems(offsets:))
            }
            .animation(nil, value: editMode?.wrappedValue)
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
        .onReceive(didSave) { _ in
            if gameRecords.isEmpty {
                dismiss()
            }
        }
    }

    // MARK: - Private

    private func openGame(withRecord record: GameRecord) {
        guard !(editMode?.wrappedValue.isEditing ?? false) else { return }
        withAnimation {
            try! gameManager.activateGame(with: record)
        }
        dismiss()
    }

    private let formatter = ListFormatter()

    private let dateFormatter = DateFormatter()

    private let didSave = NotificationCenter.default.publisher(for: NSNotification.Name.NSManagedObjectContextDidSave)

    @Environment(\.editMode)
    private var editMode

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @EnvironmentObject
    private var gameManager: GameManager

    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp)])
    private var gameRecords: FetchedResults<GameRecord>

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets
                .map { gameRecords[$0] }
                .forEach(gameManager.viewContext.delete)
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
