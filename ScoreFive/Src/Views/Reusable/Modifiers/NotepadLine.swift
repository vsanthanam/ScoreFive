// ScoreFive
// NotepadLine.swift
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

extension View {

    func notepadLine() -> some View {
        let modifier = NotepadLineModifier()
        return ModifiedContent(content: self, modifier: modifier)
    }

}

private struct NotepadLineModifier: ViewModifier {

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            content
            Rectangle()
                .fill(Color.tintColor)
                .frame(maxWidth: 0.5, maxHeight: .infinity)
                .padding(.init(top: 0, leading: 48, bottom: 0, trailing: 0))
                .ignoresSafeArea(.all, edges: [.bottom])
                .opacity(0.7)
        }
    }
}
