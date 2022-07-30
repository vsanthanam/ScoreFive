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
import Combine
import Network
import NetworkReachability
import SafariView
import SwiftUI

struct More: View {

    // MARK: - View

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "list.number")
                            .foregroundColor(.accentColor)
                        Toggle("Index By Player", isOn: $indexByPlayer)
                    }
                } header: {
                    Text("Preferences")
                }
                if reachabilityManager.reachability != .disconnected {
                    Section {
                        Button(action: {
                            safariUrl = URL(string: "https://www.vsanthanam.com/five")
                        }) {
                            HStack {
                                Image(systemName: "book")
                                Text("Instructions")
                                    .foregroundColor(.init(.label))
                                Spacer()
                                Chevron()
                            }
                        }
                        Button(action: {
                            let url = URL(string: "mailto:talkto@vsanthanam.com")!
                            UIApplication.shared.open(url)
                        }) {
                            HStack {
                                Image(systemName: "envelope")
                                Text("Email")
                                    .foregroundColor(.init(.label))
                                Spacer()
                                Chevron()
                            }
                        }
                    } header: {
                        Text("Help")
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.accentColor)
                        Text("Version")
                        Spacer()
                        Text("\(AppInfo.version) (\(AppInfo.build))")
                            .foregroundColor(.init(.secondaryLabel))
                    }
                    NavigationLink(destination: {
                        Acknowledgements()
                    }) {
                        HStack {
                            Image(systemName: "heart.text.square")
                                .foregroundColor(.accentColor)
                            Text("Acknowledgements")
                            Spacer()
                        }
                    }
                } header: {
                    Text("About")
                }
            }
            .animation(.default, value: reachabilityManager.reachability)
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
        }
        .safari(url: $safariUrl) { url in
            SafariView(url: url)
        }
    }

    // MARK: - Private

    private struct DiscloseButton<Content>: View where Content: View {

        // MARK: - Initializers

        init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
            self.content = content
            self.action = action
        }

        // MARK: - View

        var body: some View {
            Button(action: action) {
                HStack {
                    content()
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .font(Font.system(.caption).weight(.bold))
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                }
            }
            .foregroundColor(.init(.label))
        }

        // MARK: - Private

        private let content: () -> Content
        private let action: () -> Void

    }

    // MARK: - Private

    @EnvironmentObject
    private var reachabilityManager: ReachabilityManager

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

struct Chevron: View {

    var body: some View {
        Image(systemName: "chevron.forward")
            .font(Font.system(.caption).weight(.bold))
            .foregroundColor(Color(UIColor.tertiaryLabel))
    }

}
