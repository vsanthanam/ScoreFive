// ScoreFive
// Main.swift
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
import Five
import SwiftUI

/// The main view of application
struct Main: View {

    // MARK: - View

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if let identifier = gameManager.activeGameRecord {
                ScoreCard(game: try! gameManager.game(for: identifier))
            } else {
                Menu(showLoadGameButton: !gameRecords.isEmpty) { tap in
                    switch tap {
                    case .load:
                        showLoadGameSheet = true
                    case .more:
                        showMoreSheet = true
                    case .new:
                        showNewGameSheet = true
                    }
                }
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .sheet(isPresented: $showNewGameSheet) {
            NewGame()
                .saveOnAppear(gameManager)
        }
        .sheet(isPresented: $showLoadGameSheet) {
            LoadGame()
                .saveOnAppear(gameManager)
        }
        .sheet(isPresented: $showMoreSheet) {
            MoreView()
        }
        .onAppear {
            launchCount += 1
            guard !isPreview, !isUITest else { return }
            if let record = gameRecords.first, !record.isComplete {
                try! gameManager.activateGame(with: record)
            }
        }
    }

    // MARK: - Private

    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)])
    private var gameRecords: FetchedResults<GameRecord> {
        didSet {
            if let record = gameManager.activeGameRecord,
               let game = try? gameManager.game(for: record) {
                let newGames = gameRecords
                    .map { record in
                        try! gameManager.game(for: record)
                    }
                if !newGames.map(\.id).contains(game.id) {
                    withAnimation {
                        try! gameManager.deactivateGame()
                    }
                }
            }
        }
    }

    @EnvironmentObject
    private var gameManager: GameManager

    @Environment(\.isPreview)
    private var isPreview: Bool

    @Environment(\.isUITest)
    private var isUITest: Bool

    @State
    private var showNewGameSheet = false

    @State
    private var showLoadGameSheet = false

    @State
    private var showMoreSheet = false

    @AppStorage("launch_count")
    private var launchCount = 0

}

private extension View {
    func saveOnAppear(_ manager: GameManager) -> some View {
        onAppear {
            Task { await MainActor.run { try! manager.save() } }
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
            .environmentObject(GameManager.preview)
    }
}
