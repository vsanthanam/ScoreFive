// ScoreFive
// Root.swift
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

struct Root: View {

    // MARK: - View

    var body: some View {
        HStack(spacing: 0) {
            if let record = gameManager.activeGameRecord,
               let game = try? record.recordedGame {
                ScoreCard(game: game)
            } else {
                Menu(showLoadGameButton: !gameRecords.isEmpty) { tap in
                    switch tap {
                    case .load:
                        showLoadGameSheet.toggle()
                    case .more:
                        showMoreSheet.toggle()
                    case .new:
                        showNewGameSheet.toggle()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .sheet(isPresented: $showNewGameSheet) {
            NewGame()
        }
        .sheet(isPresented: $showLoadGameSheet) {
            LoadGame()
        }
        .sheet(isPresented: $showMoreSheet) {
            MoreView()
        }
        .alert("Operation Failed", isPresented: $showOperationError) {
            Button("OK") { showOperationError = false }
        } message: {
            Text("Cannot perform operation")
        }
        .onAppear {
            guard !isPreview, !isUITest else { return }
            launchCount += 1
        }
        .onReceive(gameManager.cloudPublisher) { _ in
            if !isPreview,
               !isUITest,
               gameManager.activeGameRecord != nil {
                do {
                    try gameManager.deactivateGame()
                } catch {
                    showOperationError = true
                }
            }
        }
    }

    // MARK: - Private

    @State
    private var showNewGameSheet = false

    @State
    private var showLoadGameSheet = false

    @State
    private var showMoreSheet = false

    @State
    private var showOperationError = false

    @AppStorage("launch_count")
    private var launchCount = 0

    @Environment(\.isPreview)
    private var isPreview: Bool

    @Environment(\.isUITest)
    private var isUITest: Bool

    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)])
    private var gameRecords: FetchedResults<GameRecord>

    @EnvironmentObject
    private var gameManager: GameManager

}

struct Root_Previews: PreviewProvider {

    static let manager = GameManager.preview

    static var previews: some View {
        Root()
            .environmentObject(manager)
            .environment(\.managedObjectContext, manager.viewContext)
    }
}
