// ScoreFive
// MoreView.swift
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
import SafariView
import StoreKit
import SwiftUI

/// The More screen
struct MoreView: View {

    // MARK: - View

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Toggle(isOn: $indexByPlayer) {
                            Label {
                                Text("Index By Player")
                                    .foregroundColor(.label)
                            } icon: {
                                Image(systemName: "list.number")
                            }
                        }
                    }
                } header: {
                    Text("Preferences")
                }
                Section {
                    if let url = URL(string: MoreView.twitterUrlString),
                       UIApplication.shared.canOpenURL(url) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            Cell("Twitter") {
                                Image("Twitter")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    if MailView.canSendMail {
                        Button(action: {
                            showMail = true
                        }) {
                            Cell("Email", systemName: "envelope")
                        }
                    }
                    Button(action: {
                        safariUrl = URL(string: MoreView.instructionsUrlString)
                    }) {
                        Cell("Instructions", systemName: "book")
                    }
                    if let url = URL(string: MoreView.privacyUrlString) {
                        Button(action: {
                            safariUrl = url
                        }) {
                            Cell("Privacy", systemName: "shield.lefthalf.filled")
                        }
                    }
                } header: {
                    Text("Help")
                }
                Section {
                    Button(action: shareApp) {
                        Cell("Tell a Fruend", systemName: "square.and.arrow.up")
                    }
                    Button(action: leaveReview) {
                        Cell("Rate & Review", systemName: "star.bubble")
                    }
                } header: {
                    Text("Support ScoreFive")
                }
                Section {
                    Cell("Version", systemName: "info.circle") {
                        Text("\(AppInfo.version) (\(AppInfo.build))")
                            .foregroundColor(.init(.secondaryLabel))
                    }
                    NavigationLink(destination: {
                        Acknowledgements()
                    }) {
                        Label {
                            Text("Acknowledgements")
                                .foregroundColor(.label)
                        } icon: {
                            Image(systemName: "heart.text.square")
                        }
                    }
                    Button(action: {
                        safariUrl = URL(string: MoreView.sourceCodeUrlString)
                    }) {
                        Cell("Source Code", systemName: "chevron.left.forwardslash.chevron.right")
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("More")
            .closeButton { dismiss() }
        }
        .safari(url: $safariUrl) { url in
            SafariView(url: url)
        }
        .mailView(isPresented: $showMail) {
            MailView()
                .toRecipents(["talkto@vsanthanam.com"])
                .subject("Help with ScoreFive")
                .messageBody("I need some help with ScoreFive!")
        }
        .onAppear {
            let urls = [MoreView.instructionsUrlString,
                        MoreView.twitterUrlString,
                        MoreView.privacyUrlString,
                        MoreView.sourceCodeUrlString]
                .compactMap(URL.init(string:))
            token = SafariView.prewarmConnections(to: urls)
        }
        .onDisappear {
            token?.invalidate()
        }
    }

    // MARK: - Private

    @State
    private var token: SafariView.PrewarmingToken?

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @State
    private var safariUrl: URL?

    @State
    private var showMail = false

    @AppStorage("index_by_player")
    private var indexByPlayer = true

    @AppStorage("requested_review")
    private var requestedReview = false

    private static let instructionsUrlString = "https://www.scorefive.app"
    private static let twitterUrlString = "https://twitter.vsanthanam.com"
    private static let privacyUrlString = "https://www.scorefive.app/privacy"
    private static let sourceCodeUrlString = "https://www.github.com/vsanthanam/ScoreFive"

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

    private func shareApp() {
        guard let url = URL(string: "https://itunes.apple.com/app/id1637035385"),
              let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first,
              let vc = window.rootViewController?.presentedViewController else {
            return
        }
        print(String(describing: vc.self))
        print(vc.view.subviews)
        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            av.popoverPresentationController?.sourceView = vc.view
            av.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
        }
        vc.present(av, animated: true, completion: nil)
    }
}

private struct Cell<Icon: View, Accessory: View>: View {

    init(_ title: String, systemName: String) where Icon == Image, Accessory == Chevron {
        self.title = title
        icon = { Image(systemName: systemName) }
        accessory = { Chevron() }
    }

    init(_ title: String, @ViewBuilder icon: @escaping () -> Icon) where Accessory == Chevron {
        self.title = title
        self.icon = icon
        accessory = { Chevron() }
    }

    init(_ title: String, systemName: String, @ViewBuilder accessory: @escaping () -> Accessory) where Icon == Image {
        self.title = title
        icon = { Image(systemName: systemName) }
        self.accessory = accessory
    }

    init(_ title: String, @ViewBuilder icon: @escaping () -> Icon, @ViewBuilder accessory: @escaping () -> Accessory) {
        self.title = title
        self.icon = icon
        self.accessory = accessory
    }

    let title: String
    private let icon: () -> Icon
    private let accessory: () -> Accessory

    var body: some View {
        HStack {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                icon()
            }
            Spacer()
            accessory()
        }
    }
}

struct More_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            MoreView()
                .colorScheme(scheme)
        }
    }
}
