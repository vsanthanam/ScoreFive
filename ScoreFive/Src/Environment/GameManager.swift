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

import Combine
import CoreData
import Five
import Foundation
import Outils
import SwiftUI

@MainActor
final class GameManager: ObservableObject {

    // MARK: - Factories

    static let shared: GameManager = .init()

    // MARK: - API

    enum Error: Swift.Error {
        case noGameFound
        case noActiveGame
        case gameAlreadyActive
    }

    var viewContext: NSManagedObjectContext {
        store.viewContext
    }

    @Published
    private(set) var activeGameRecord: GameRecord? = nil

    func storeNewGame(_ game: Game) throws -> GameRecord {
        let record = GameRecord(context: viewContext)
        try record.applyGame(game)
        return record
    }

    func updateGame(_ game: Game) throws {
        guard let record = activeGameRecord else {
            throw Error.noActiveGame
        }
        try record.applyGame(game)
    }

    func activateGame(with record: GameRecord) throws {
        guard activeGameRecord == nil else {
            throw Error.gameAlreadyActive
        }
        activeGameRecord = record
    }

    func deactivateGame() throws {
        guard activeGameRecord != nil else {
            throw Error.noActiveGame
        }
        activeGameRecord = nil
    }

    func save() throws {
        guard viewContext.hasChanges else { return }
        try viewContext.save()
    }

    func destroyAllRecords() throws {
        try? deactivateGame()
        let fetchRequest = GameRecord.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        let results = try viewContext.fetch(fetchRequest)
        for result in results {
            viewContext.delete(result)
        }
    }

    public var cloudPublisher: AnyPublisher<Notification, Never> {
        _cloudPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private lazy var _cloudPublisher = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange, object: store.persistentStoreCoordinator)

    // MARK: - Private

    private init(inMemory: Bool = false) {
        setUp(inMemory: inMemory)
    }

    private var store: NSPersistentCloudKitContainer!

    private func setUp(inMemory: Bool) {
        guard let url = Bundle.main.url(forResource: "ScoreFive", withExtension: "momd") else { fatalError() }
        guard let model = NSManagedObjectModel(contentsOf: url) else { fatalError() }
        store = NSPersistentCloudKitContainer(name: "ScoreFive", managedObjectModel: model)
        if inMemory {
            store.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            store.persistentStoreDescriptions.first!.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            store.persistentStoreDescriptions.first!.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
        store.loadPersistentStores { store, error in
            if let error = error as? NSError {
                fatalError(error.description)
            }
        }
        store.viewContext.mergePolicy = NSOverwriteMergePolicy
        store.viewContext.automaticallyMergesChangesFromParent = true
    }

}

extension GameRecord {
    fileprivate func applyGame(_ game: Game, timestampe: Date = .now) throws {
        let data = try JSONEncoder().encode(game)
        gameData = data
        timestamp = .now
        playerNames = .init(game.allPlayers)
        gameIdentifier = game.id
        isComplete = game.isComplete
    }

    var recordedGame: Game {
        get throws {
            guard let gameData = gameData else {
                throw AnyError("No Game Data In Record!")
            }
            return try JSONDecoder().decode(Game.self, from: gameData)
        }
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
