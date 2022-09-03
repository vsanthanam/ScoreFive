// ScoreFive
// Acknowledgements.swift
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
import SafariView
import SwiftUI

struct Acknowledgements: View {

    // MARK: - View

    var body: some View {
        List {
            Section {
                ForEach(Acknowledgements.tools.sorted(by: \.title)) { item in
                    Row(item: item) { item in
                        activeSafariUrl = URL(string: item.urlString)
                    }
                }
            } header: {
                Text("Made with these tools")
            }
            Section {
                ForEach(Acknowledgements.services.sorted(by: \.title)) { item in
                    Row(item: item) { item in
                        activeSafariUrl = URL(string: item.urlString)
                    }
                }
            } header: {
                Text("Powered by these services")
            }
        }
        .navigationTitle("Acknowledgements")
        .navigationBarTitleDisplayMode(.inline)
        .safari(url: $activeSafariUrl) { url in
            SafariView(url: url)
        }
    }

    // MARK: - Private

    private static let tools = [
        Acknowledgement(title: "Introspect",
                        urlString: "https://github.com/siteline/SwiftUI-Introspect"),
        Acknowledgement(title: "SafariView",
                        urlString: "https://vsanthanam.github.io/SafariView"),
        Acknowledgement(title: "MailView",
                        urlString: "https://www.github.com/vsanthanam/MailView"),
    ]

    private static let services = [
        Acknowledgement(title: "Fastlane", urlString: "https://fastlane.tools"),
        Acknowledgement(title: "Jekyll", urlString: "https://jekyllrb.com"),
    ]

    @State
    private var activeSafariUrl: URL?

    private struct Row: View {

        // MARK: - Initializers

        init(item: Acknowledgement,
             action: @escaping (Acknowledgement) -> Void) {
            self.item = item
            self.action = action
        }

        // MARK: - View

        var body: some View {
            Button(action: {
                action(item)
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.body)
                            .foregroundColor(.label)
                        Text(item.urlString)
                            .font(.caption)
                            .foregroundColor(.secondaryLabel)
                    }
                    Spacer()
                    Chevron()
                }
            }
        }

        // MARK: - Private

        private let item: Acknowledgement
        private let action: (Acknowledgement) -> Void
    }
}

struct Acknowledgements_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            NavigationView {
                Acknowledgements()
            }
            .colorScheme(scheme)
        }
    }
}
