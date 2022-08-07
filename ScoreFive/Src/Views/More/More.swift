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
import MailView
import Network
import NetworkReachability
import SafariView
import StoreKit
import SwiftUI

/// The More screen
struct More: View {

    // MARK: - View

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "list.number")
                            .frame(maxWidth: 20, alignment: .center)
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
                                    .frame(maxWidth: 20, alignment: .center)
                                Text("Instructions")
                                    .foregroundColor(.init(.label))
                                Spacer()
                                Chevron()
                            }
                        }
                        if MailView.canSendMail {
                            Button(action: {
                                showMail = true
                            }) {
                                HStack {
                                    Image(systemName: "envelope")
                                        .frame(maxWidth: 20, alignment: .center)
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
                                .frame(maxWidth: 20, alignment: .center)
                            Text("Rate & Review")
                                .foregroundColor(.init(.label))
                            Spacer()
                            if reachabilityManager.reachability != .disconnected {
                                Chevron()
                            }
                        }
                    }
                    .disabled(reachabilityManager.reachability == .disconnected)
                    Button(action: {
                        guard let url = URL(string: "https://itunes.apple.com/app/id1637035385"),
                              let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let window = scene.windows.first else {
                            return
                        }
                        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        window.rootViewController?.presentedViewController?.present(av, animated: true, completion: nil)
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .frame(maxWidth: 20, alignment: .center)
                            Text("Tell a Friend")
                                .foregroundColor(.init(.label))
                            Spacer()
                            if reachabilityManager.reachability != .disconnected {
                                Chevron()
                            }
                        }
                    }
                    .disabled(reachabilityManager.reachability == .disconnected)
                } header: {
                    Text("Support ScoreFive")
                }
                Section {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: 20, alignment: .center)
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
                                .frame(maxWidth: 20, alignment: .center)
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
            .closeButton { dismiss() }
        }
        .safari(url: $safariUrl) { url in
            SafariView(url: url)
        }
        .sheet(isPresented: $showMail) {
            MailView()
                .toRecipents(["talkto@vsanthanam.com"])
                .subject("Help with ScoreFive")
                .messageBody("I need some help with ScoreFive!")
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

    @State
    private var showMail = false

    @AppStorage("index_by_player")
    private var indexByPlayer = true

    @AppStorage("requested_review")
    private var requestedReview = false

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
            .environmentObject(ReachabilityManager.shared)
    }
}
