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

import Introspect
import SwiftUI
import UIKit

extension View {

    func closeButton(_ placement: CloseButtonPlacement = .trailing,
                     action: @escaping () -> Void) -> some View {
        let modifier = CloseButtonModifier(placement: placement, action: action)
        return ModifiedContent(content: self, modifier: modifier)
    }

}

enum CloseButtonPlacement {
    case leading
    case trailing
}

private struct CloseButtonModifier: ViewModifier {

    // MARK: - API

    let placement: CloseButtonPlacement

    let action: () -> Void

    // MARK: - ViewModifier

    func body(content: Content) -> some View {
        content
            .introspectViewController { viewController in
                let closeItem = UIBarButtonItem(systemItem: .close,
                                                primaryAction: UIAction { _ in
                                                    action()
                                                }, menu: nil)
                switch (direction, placement) {
                case (.leftToRight, .leading):
                    viewController.navigationItem.leftBarButtonItem = closeItem
                case (.rightToLeft, .leading):
                    viewController.navigationItem.rightBarButtonItem = closeItem
                case (.leftToRight, .trailing):
                    viewController.navigationItem.rightBarButtonItem = closeItem
                case (.rightToLeft, .trailing):
                    viewController.navigationItem.leftBarButtonItem = closeItem
                @unknown default:
                    viewController.navigationItem.rightBarButtonItem = closeItem
                }
            }
    }

    // MARK: - Private

    @Environment(\.layoutDirection)
    private var direction: LayoutDirection

}
