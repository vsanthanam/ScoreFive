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
import StoreKit
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
                            safariUrl = URL(string: "https://www.scorefive.app")
                        }) {
                            HStack {
                                Image(systemName: "book")
                                Text("Instructions")
                                    .foregroundColor(.init(.label))
                                Spacer()
                                Chevron()
                            }
                        }
                        if let url = URL(string: More.mailUrlString),
                           UIApplication.shared.canOpenURL(url) {
                            Button(action: {
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
                        }
                        if let url = URL(string: More.twitterUrlString),
                           UIApplication.shared.canOpenURL(url) {
                            Button(action: {
                                UIApplication.shared.open(url)
                            }) {
                                HStack {
                                    Image("Twitter")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .foregroundColor(.accentColor)
                                    Text("Twitter")
                                        .foregroundColor(.init(.label))
                                    Spacer()
                                    Chevron()
                                }
                            }
                        }
                    } header: {
                        Text("Help")
                    }
                }
                Section {
                    Button(action: leaveReview) {
                        HStack {
                            Image(systemName: "star.bubble")
                            Text("Rate & Review")
                                .foregroundColor(.init(.label))
                            Spacer()
                            Chevron()
                        }
                    }
                    Button(action: {
                        showShareSheet = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share ScoreFive")
                                .foregroundColor(.init(.label))
                            Spacer()
                            Chevron()
                        }
                    }
                    .shareSheet(isPresented: $showShareSheet, items: [URL(string: "https://itunes.apple.com/app/id1637035385")!])
                } header: {
                    Text("Support ScoreFive")
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
            .introspectViewController { viewController in
                let closeItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
                    dismiss()
                }, menu: nil)
                viewController.navigationItem.leftBarButtonItem = closeItem
            }
        }
        .safari(url: $safariUrl) { url in
            SafariView(url: url)
        }
    }

    // MARK: - Private

    @EnvironmentObject
    private var reachabilityManager: ReachabilityManager

    @SwiftUI.Environment(\.dismiss)
    private var dismiss: DismissAction

    @State
    private var safariUrl: URL?

    @State
    private var showShareSheet = false

    @AppStorage("index_by_player")
    private var indexByPlayer = true

    @AppStorage("requested_review")
    private var requestedReview = false

    private static let mailUrlString = "mailto:talkto@vsanthanam.com"

    private static let twitterUrlString = "https://twitter.vsanthanam.com"

    private func leaveReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           !requestedReview {
            SKStoreReviewController.requestReview(in: scene)
            requestedReview = true
        } else if let url = URL(string: "https://itunes.apple.com/app/id1637035385?action=write-review"),
                  UIApplication.shared.canOpenURL(url) {
            Task { await UIApplication.shared.open(url, options: [:]) }
        }
    }
}

struct More_Previews: PreviewProvider {
    static var previews: some View {
        More()
    }
}
