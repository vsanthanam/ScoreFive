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

    // MARK: - View

    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle("Show Complete Games", isOn: $showCompleteGames.animation(.default))
                }
                Section {
                    ForEach(showCompleteGames ? gameRecords : inProgressGameRecords) { record in
                        Button {
                            openGame(withRecord: record)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(formatter.string(from: record.playerNames ?? []) ?? "")
                                Text("Last updated at \(dateFormatter.string(from: record.timestamp ?? .now))")
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.init(.label))
                    }
                    .onDelete(perform: deleteItems(offsets:))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if hasContent, (editButtonMode == listEditMode) {
                        EditButton()
                            .environment(\.editMode, $editButtonMode)
                    } else {
                        EmptyView()
                    }
                }

            }
            .environment(\.editMode, $listEditMode)
            .navigationTitle("Load Game")
        }
        .onReceive(didSave) { _ in
            if gameRecords.isEmpty {
                dismiss()
            }
        }
        .onChange(of: editButtonMode) { mode in
            withAnimation {
                self.listEditMode = mode
            }
        }
    }

    // MARK: - Private

    private let formatter = ListFormatter()

    private let dateFormatter = DateFormatter()

    private let didSave = NotificationCenter.default.publisher(for: NSNotification.Name.NSManagedObjectContextDidSave)

    @AppStorage("show_complete_games")
    private var showCompleteGames: Bool = false

    @State
    private var editButtonMode: EditMode = .inactive

    @State
    private var listEditMode: EditMode = .inactive

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @EnvironmentObject
    private var gameManager: GameManager

    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp)])
    private var gameRecords: FetchedResults<GameRecord>

    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp)], predicate: NSPredicate(format: "isComplete == NO"))
    private var inProgressGameRecords: FetchedResults<GameRecord>

    private var hasContent: Bool {
        if showCompleteGames {
            return !gameRecords.isEmpty
        } else {
            return !inProgressGameRecords.isEmpty
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets
                .map { showCompleteGames ? gameRecords[$0] : inProgressGameRecords[$0] }
                .forEach(gameManager.viewContext.delete)
            try! gameManager.save()
        }
    }

    private func openGame(withRecord record: GameRecord) {
        guard !listEditMode.isEditing else { return }
        withAnimation {
            try! gameManager.activateGame(with: record)
        }
        dismiss()
    }

}

struct LoadGame_Previews: PreviewProvider {
    static var previews: some View {
        LoadGame()
            .environmentObject(GameManager.preview)
    }
}
