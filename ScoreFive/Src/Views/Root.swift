//
//  Root.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/10/22.
//

import SwiftUI

struct Root: View {

    // MARK: - Initializers

    init(gameManager: GameManager) {
        _gameManager = .init(wrappedValue: gameManager)
    }

    // MARK: - View

    var body: some View {
        MainMenu()
            .environmentObject(gameManager)
    }

    // MARK: - Private

    @StateObject
    private var gameManager: GameManager
}

struct Root_Previews: PreviewProvider {
    static var previews: some View {
        Root(gameManager: .preview)
    }
}
