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

import SwiftUI
import UIKit

struct PlayerTextField: View {

    init(index: Int, player: Binding<String>, submitLabel: SubmitLabel = .next) {
        self.index = index
        self.player = player
        self.submitLabel = submitLabel
    }

    let index: Int

    let player: Binding<String>

    let submitLabel: SubmitLabel

    var body: some View {
        TextField("Player \(index + 1)", text: player)
            .autocapitalization(.words)
            .keyboardType(.default)
            .disableAutocorrection(true)
            .submitLabel(submitLabel)
    }
}

struct PlayerTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerTextField(index: 0, player: .constant("Mom"))
                .previewLayout(PreviewLayout.sizeThatFits)
            PlayerTextField(index: 0, player: .constant(""))
                .previewLayout(PreviewLayout.sizeThatFits)
        }
    }
}
