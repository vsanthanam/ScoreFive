// ScoreFive
// AcknowledgementView.swift
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

import Foundation
import SwiftUI

struct AcknowledgementView: View {

    // MARK: - Initializers

    init(item: Acknowledgement, url: Binding<URL?>) {
        self.item = item
        self.url = url
    }

    // MARK: - View

    var body: some View {
        Button(action: {
            url.wrappedValue = URL(string: item.urlString)
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .foregroundColor(.init(.label))
                    Text(item.urlString)
                        .foregroundColor(.init(.secondaryLabel))
                        .font(.caption)
                }
                Spacer()
                if reachabilityManager.reachability != .disconnected {
                    Chevron()
                }
            }
        }
        .disabled(reachabilityManager.reachability == .disconnected)
    }

    // MARK: - Private

    private let item: Acknowledgement
    private let url: Binding<URL?>

    @EnvironmentObject
    private var reachabilityManager: ReachabilityManager
}