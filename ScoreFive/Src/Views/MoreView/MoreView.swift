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

import Combine
import MailView
import Network
import Outils
import SafariView
import StoreKit
import SwiftUI

struct MoreView: View {

    // MARK: - View

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Toggle(isOn: $indexByPlayer) {
                            Label("Index By Player", systemImage: "list.number")
                        }
                    }
                } header: {
                    Text("Preferences")
                }
                Section {
                    Button(action: openTwitter) {
                        HStack {
                            Label(title: {
                                Text("Twitter")
                            }, icon: twitterIcon)
                            Spacer()
                            Chevron()
                        }
                    }
                    if MailView.canSendMail || isUITest {
                        Button(action: sendEmail) {
                            HStack {
                                Label("Email", systemImage: "envelope")
                                Spacer()
                                Chevron()
                            }
                        }
                    }
                    Button(action: openInstructions) {
                        HStack {
                            Label("Instructions", systemImage: "book")
                            Spacer()
                            Chevron()
                        }
                    }
                    Button(action: viewPrivacy) {
                        HStack {
                            Label("Privacy", systemImage: "shield.lefthalf.filled")
                            Spacer()
                            Chevron()
                        }
                    }
                } header: {
                    Text("Help")
                }
                Section {
                    Button(action: shareApp) {
                        HStack {
                            Label("Tell a Friend", systemImage: "square.and.arrow.up")
                            Spacer()
                            Chevron()
                        }
                    }
                    Button(action: leaveReview) {
                        HStack {
                            Label("Rate & Review", systemImage: "star.bubble")
                            Spacer()
                            Chevron()
                        }
                    }
                } header: {
                    Text("Support ScoreFive")
                }
                Section {
                    Label("Version", systemImage: "info.circle")
                        .badge("\(AppInfo.version) (\(AppInfo.build))")
                    NavigationLink(destination: {
                        Acknowledgements()
                    }) {
                        Label("Acknowledgements", systemImage: "heart.text.square")
                    }
                    Button(action: viewSourceCode) {
                        HStack {
                            Label("Source Code", systemImage: "chevron.left.forwardslash.chevron.right")
                            Spacer()
                            Chevron()
                        }
                    }
                } header: {
                    Text("About")
                }
            }
            .labelStyle(.cell)
            .navigationTitle("More")
            .closeButton { dismiss() }
        }
        .safari(item: $safariUrl) { url in
            SafariView(url: URL(string: url.rawValue)!)
        }
        .mailView(isPresented: $showMail) {
            MailView()
                .toRecipents(["talkto@vsanthanam.com"])
                .subject("Help with ScoreFive")
                .messageBody("I need some help with ScoreFive!")
        }
        .onAppear {
            let urls = SafariURL
                .allCases
                .map(\.rawValue)
                .compactMap(URL.init(string:))
            token = SafariView.prewarmConnections(to: urls)
        }
        .onDisappear {
            token?.invalidate()
        }
    }

    // MARK: - Private

    private enum SafariURL: String, CaseIterable, Identifiable {
        case instructions = "https://www.scorefive.app"
        case privacy = "https://www.scorefive.app/privacy"
        case sourceCode = "https://www.github.com/vsanthanam/ScoreFive"

        var id: String { rawValue }
    }

    @State
    private var token: SafariView.PrewarmingToken?

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @Environment(\.isUITest)
    private var isUITest: Bool

    @Environment(\.openURL)
    private var openURL: OpenURLAction

    @State
    private var safariUrl: SafariURL?

    @State
    private var showMail = false

    @AppStorage("index_by_player")
    private var indexByPlayer = true

    @AppStorage("requested_review")
    private var requestedReview = false

    @ViewBuilder
    private func twitterIcon() -> some View {
        Image("Twitter")
            .renderingMode(.template)
            .resizable()
            .frame(width: 20, height: 20, alignment: .center)
            .foregroundColor(.accentColor)
    }

    private func sendEmail() {
        showMail = true
    }

    private func leaveReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           !requestedReview {
            SKStoreReviewController.requestReview(in: scene)
            requestedReview = true
        } else if let url = URL(string: "https://itunes.apple.com/app/id1637035385?action=write-review"),
                  UIApplication.shared.canOpenURL(url) {
            openURL(url)
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

    private func viewPrivacy() {
        safariUrl = .privacy
    }

    private func viewSourceCode() {
        safariUrl = .sourceCode
    }

    private func openInstructions() {
        safariUrl = .instructions
    }

    private func openTwitter() {
        guard let url = URL(string: "https://twitter.vsanthanam.com"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        openURL(url)
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
