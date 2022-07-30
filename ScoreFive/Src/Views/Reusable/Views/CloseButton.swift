// ScoreFive
// CloseButton.swift
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

struct CloseButton: View {

    // MARK: - Initializers

    init(action: @escaping () -> Void) {
        self.action = action
    }

    // MARK: - API

    func size(_ points: Double) -> CloseButton {
        var copy = self
        copy.size = points
        return copy
    }

    // MARK: - View

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color(.secondarySystemBackground))
                .frame(width: size, height: size) // You can make this whatever size, but keep UX in mind.
                .overlay(
                    Image(systemName: "xmark")
                        .font(.system(size: size / 2.5, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                )
        }
    }

    // MARK: - Private

    private var size: Double = 30
    private let action: () -> Void
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton() {}
            .size(12)
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
