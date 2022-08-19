// ScoreFive
// GameManager.swift
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
import Foundation

/// A singleton object used to write games to CoreData and to manage the currently open game
/// UIKit interacts with this class via its `.shared` static property
/// SwiftUI interacts with this class using the EnvironmentObject API.
@MainActor
final class GameManager: ObservableObject {

    // MARK: - Factories

    /// The shared singleton instance.
    static let shared: GameManager = .init()

    // MARK: - API

    /// Errors produced by a `GameManager`
    enum Error: Swift.Error {
        case noGameFound
        case noActiveGame
        case gameAlreadyActive
    }

    /// The Core Data View Context
    var viewContext: NSManagedObjectContext {
        store.viewContext
    }

    /// The currently active game record
    @Published
    private(set) var activeGameRecord: GameRecord? = nil

    /// Store a new game in Core Data
    /// - Parameter game: The game to store
    /// - Returns: The associated managed object
    /// - Throws: An error, if the game could not be translated into a `GameRecord`
    func storeNewGame(_ game: Game) throws -> GameRecord {
        let record = GameRecord(context: viewContext)
        try record.applyGame(game)
        return record
    }

    /// Retrieve a game for a given managed object
    /// - Parameter record: The `GameRecord` to retrieve
    /// - Returns: The `Game` stored in the managed object
    /// - Throws: An error, if the game could not be decoded from the managed object.
    func game(for record: GameRecord) throws -> Game {
        guard let gameData = record.gameData else {
            throw Error.noGameFound
        }
        let game = try JSONDecoder().decode(Game.self, from: gameData)
        return game
    }

    /// Replace the currently active record with new game data
    /// - Parameter game: The game data to update
    /// - Throws: An error, if no record is active, or if the game could not be encoded into the managed object.
    func updateGame(_ game: Game) throws {
        guard let record = activeGameRecord else {
            throw Error.noActiveGame
        }
        try record.applyGame(game)
    }

    /// Activate a managed object
    /// - Parameter record: The `GameRecord` to activate
    /// - Throws: An error, if an existing managed object is already active
    func activateGame(with record: GameRecord) throws {
        guard activeGameRecord == nil else {
            throw Error.gameAlreadyActive
        }
        activeGameRecord = record
    }

    /// Deactivate the current managed object
    /// - Throws: An error, if no managed object is currently active
    func deactivateGame() throws {
        guard activeGameRecord != nil else {
            throw Error.noActiveGame
        }
        activeGameRecord = nil
    }

    /// Save the store to disk
    /// - Throws: An error, if saving failed
    func save() throws {
        guard viewContext.hasChanges else { return }
        try viewContext.save()
    }

    /// Remove every record in the store
    /// - Throws: An error, if destruction failed.
    func destroyAllRecords() throws {
        try? deactivateGame()
        let fetchRequest = GameRecord.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        let results = try viewContext.fetch(fetchRequest)
        for result in results {
            viewContext.delete(result)
        }
        try save()
    }

    // MARK: - Private

    private var store: NSPersistentCloudKitContainer!

    private init(inMemory: Bool = false) {
        setUp(inMemory: inMemory)
    }

    private func setUp(inMemory: Bool) {
        guard let url = Bundle.main.url(forResource: "ScoreFive", withExtension: "momd") else { fatalError() }
        guard let model = NSManagedObjectModel(contentsOf: url) else { fatalError() }
        store = NSPersistentCloudKitContainer(name: "ScoreFive", managedObjectModel: model)
        if inMemory {
            store.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        store.loadPersistentStores { store, error in
            if let error = error as? NSError {
                fatalError(error.description)
            }
        }
        store.viewContext.automaticallyMergesChangesFromParent = true
    }
}

private extension GameRecord {
    func applyGame(_ game: Game, timestampe: Date = .now) throws {
        let data = try JSONEncoder().encode(game)
        gameData = data
        timestamp = .now
        playerNames = .init(game.allPlayers)
        isComplete = game.isComplete
    }
}

extension GameManager {

    /// For SwiftUI Previews
    static let preview: GameManager = {
        let manager = GameManager(inMemory: true)
        let context = manager.viewContext
        var firstGame = Game(players: ["Mom", "Dad", "God", "Bro"], scoreLimit: 250)
        var round = firstGame.newRound()
        round["Mom"] = 0
        round["Dad"] = 23
        round["God"] = 35
        round["Bro"] = 11
        firstGame.addRound(round)
        let record = GameRecord(context: context)
        try! record.applyGame(firstGame)
        try! context.save()
        return manager
    }()
}
