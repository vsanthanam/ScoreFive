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

@MainActor
final class GameManager: ObservableObject {

    // MARK: - Factories

    static let preview: GameManager = {
        let manager = GameManager()
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

    static let shared: GameManager = .init()

    // MARK: - API

    enum Error: Swift.Error {
        case noGameFound
        case noActiveGame
    }

    var viewContext: NSManagedObjectContext {
        store.viewContext
    }

    func storeNewGame(_ game: Game) throws -> GameRecord {
        let record = GameRecord(context: viewContext)
        try record.applyGame(game)
        return record
    }

    func game(for record: GameRecord) throws -> Game {
        guard let gameData = record.gameData else {
            throw Error.noGameFound
        }
        let game = try JSONDecoder().decode(Game.self, from: gameData)
        return game
    }

    func updateGame(_ game: Game) throws {
        guard let record = activeGameRecord else {
            throw Error.noActiveGame
        }
        try record.applyGame(game)
    }

    func activateGame(with record: GameRecord) throws {
        activeGameRecord = record
    }

    func deactivateGame() throws {
        guard activeGameRecord != nil else {
            throw Error.noActiveGame
        }
        activeGameRecord = nil
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
    private(set) var activeGameRecord: GameRecord?

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

private extension GameRecord {
    func applyGame(_ game: Game, timestampe: Date = .now) throws {
        let data = try JSONEncoder().encode(game)
        gameData = data
        timestamp = .now
        playerNames = .init(game.allPlayers)
    }
}
