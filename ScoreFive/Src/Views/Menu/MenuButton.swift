// ScoreFive
// MenuButton.swift
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

struct MenuButton: View {

    // MARK: - Initializers

    init(_ message: String,
         systemName: String,
         action: @escaping () -> Void = {}) {
        self.message = message
        self.systemName = systemName
        self.action = action
    }

    // MARK: - View

    var body: some View {

        Button(action: action) {
            HStack {
                Image(systemName: systemName)
                Text(message)
            }
            .frame(width: 140)
        }
        .buttonStyle(.borderedProminent)
    }

    // MARK: - Private

    private let action: () -> Void
    private let message: String
    private let systemName: String

}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            MenuButton("New Game", systemName: "doc.badge.plus")
                .previewLayout(PreviewLayout.sizeThatFits)
                .colorScheme(scheme)
        }
    }
}
