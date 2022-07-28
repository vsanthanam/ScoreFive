// ScoreFive
// More.swift
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

import AppFoundation
import SafariView
import SwiftUI

struct More: View {

    // MARK: - View

    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle("Index By Player", isOn: $indexByPlayer)
                } header: {
                    Text("Preferences")
                }
                Section {
                    DiscloseButton {
                        safariUrl = URL(string: "https://www.vsanthanam.com/five")
                    } label: {
                        Text("Game Instructions")
                    }
                } header: {
                    Text("Help")
                }
                Section {
                    DiscloseButton(action: {
                        let url = URL(string: "https://twitter.vsanthanam.com")!
                        UIApplication.shared.open(url)
                    }) {
                        Text("Twitter")
                    }
                    DiscloseButton(action: {
                        safariUrl = URL(string: "https://www.vsanthanam.com")
                    }) {
                        Text("Website")
                    }
                } header: {
                    Text("Contact")
                }
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(AppInfo.version)
                            .foregroundColor(.init(.secondaryLabel))
                    }
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(AppInfo.build)
                            .foregroundColor(.init(.secondaryLabel))
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("More")
        }
        .safari(url: $safariUrl) { url in
            SafariView(url: url)
        }
    }

    // MARK: - Private

    private struct DiscloseButton<Content>: View where Content: View {

        // MARK: - Initializers

        init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
            self.label = label
            self.action = action
        }

        // MARK: - View

        var body: some View {
            Button(action: action) {
                HStack {
                    label()
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .font(Font.system(.caption).weight(.bold))
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                }
            }
            .foregroundColor(.init(.label))
        }

        // MARK: - Private

        private let label: () -> Content
        private let action: () -> Void

    }

    @State
    private var safariUrl: URL?

    @AppStorage("index_by_player")
    private var indexByPlayer = true

}

struct More_Previews: PreviewProvider {
    static var previews: some View {
        More()
    }
}
