// ScoreFive
// Menu.swift
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

import SwiftUI

/// The home menu
struct Menu: View {

    // MARK: - API

    /// A binding to accept sheets from user taps
    @Binding
    var activeSheet: Main.Sheets?

    // MARK: - View

    var body: some View {
        VStack {
            Image("IconSymbol")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.menuContent)
                .frame(width: 100, height: 100, alignment: .center)
            Spacer()
                .frame(maxHeight: 25)
            MenuButton("New Game",
                       systemName: "square.and.pencil") {
                activeSheet = .newGame
            }

            if !gameRecords.isEmpty {
                MenuButton("Load Game",
                           systemName: "doc.badge.ellipsis") {
                    activeSheet = .loadGame
                }
            }

            MenuButton("More",
                       systemName: "ellipsis.circle") {
                activeSheet = .more
            }
        }
        .rootStatusBarStyle(.alwaysLight)
    }

    // MARK: - Private

    @EnvironmentObject
    private var gameManager: GameManager

    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp)])
    private var gameRecords: FetchedResults<GameRecord>

}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            Menu(activeSheet: .constant(nil))
                .environmentObject(GameManager.preview)
                .background(Color.mainBackground)
                .previewLayout(PreviewLayout.sizeThatFits)
                .colorScheme(scheme)
        }
    }
}
