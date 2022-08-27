// ScoreFive
// PlayerTextField.swift
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

import ListCell
import SwiftUI

struct PlayerTextField: View {

    // MARK: - Initializers

    init(index: Int,
         player: Binding<String>,
         submitLabel: SubmitLabel = .next) {
        self.index = index
        self.player = player
        self.submitLabel = submitLabel
    }

    // MARK: - View

    var body: some View {
        ListCell(placeholder: "Player \(index + 1)", input: player)
            .autocapitalization(.words)
            .keyboardType(.default)
            .disableAutocorrection(true)
            .submitLabel(submitLabel)
    }

    // MARK: - Private

    private let index: Int
    private let player: Binding<String>
    private let submitLabel: SubmitLabel
}
