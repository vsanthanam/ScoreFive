//
//  GameManager.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/10/22.
//

import CoreData
import Five
import Foundation

final class GameManager: ObservableObject {

    // MARK: - Factories

    static let preview: GameManager = .init()

    static let shared: GameManager = .init()

    // MARK: - API

    enum Error: Swift.Error {
        case noGameFound
        case noActiveGame
    }

    var viewContext: NSManagedObjectContext {
        store.viewContext
    }

    func storeNewGame(_ game: Game) throws -> NSManagedObjectID {
        let record = GameRecord(context: viewContext)
        let data = try JSONEncoder().encode(game)
        record.gameData = data
        record.timestamp = .now
        record.playerNames = .init(game.allPlayers())
        return record.objectID
    }

    func game(for id: NSManagedObjectID) throws -> Game {
        guard let result = viewContext.registeredObject(for: id),
              let record = result as? GameRecord,
              let gameData = record.gameData else {
            throw Error.noGameFound
        }
        let game = try JSONDecoder().decode(Game.self, from: gameData)
        return game
    }

    func activateGame(with id: NSManagedObjectID) throws {
        guard let result = viewContext.registeredObject(for: id),
              let _ = result as? GameRecord else {
            throw Error.noGameFound
        }
        activeGameIdentifier = id
    }

    func deactivateGame() throws {
        guard activeGameIdentifier != nil else {
            throw Error.noActiveGame
        }
        activeGameIdentifier = nil
    }

    func deleteGame(identifier: NSManagedObjectID) throws {
        guard let record = viewContext.registeredObject(for: identifier) else {
            throw Error.noGameFound
        }
        viewContext.delete(record)
    }

    func save() throws {
        guard viewContext.hasChanges else { return }
        try viewContext.save()
    }

    // MARK: - Private

    @Published
    private(set) var activeGameIdentifier: NSManagedObjectID?

    private init(inMemory: Bool = false) {
        setUp(inMemory: inMemory)
    }

    private func setUp(inMemory: Bool) {
        guard let url = Bundle.main.url(forResource: "ScoreFive", withExtension: "momd") else { fatalError() }
        guard let model = NSManagedObjectModel(contentsOf: url) else { fatalError() }
        store = NSPersistentContainer(name: "ScoreFive", managedObjectModel: model)
        if inMemory {
            store.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        store.loadPersistentStores { store, error in
            if let error = error as? NSError {
                fatalError(error.description)
            } else {
                print(store)
            }
        }
    }

    private var store: NSPersistentContainer!
}
