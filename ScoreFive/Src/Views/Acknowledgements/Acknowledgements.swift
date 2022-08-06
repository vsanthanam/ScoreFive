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
                ForEach(Acknowledgements.libraries.sorted(by: \.title)) { item in
                    AcknowledgementView(item: item, url: $safariUrl)
                }
            } header: {
                Text("Made with these libraries")
            }
            Section {
                ForEach(Acknowledgements.tools.sorted(by: \.title)) { item in
                    AcknowledgementView(item: item, url: $safariUrl)
                }
            } header: {
                Text("Powered by these tools")
            }
        }
        .navigationTitle("Acknowledgements")
        .navigationBarTitleDisplayMode(.inline)
        .safari(url: $safariUrl) { url in
            SafariView(url: url)
        }
    }

    // MARK: - Private

    private static let libraries = [
        Acknowledgement(title: "Introspect", urlString: "https://github.com/siteline/SwiftUI-Introspect"),
        Acknowledgement(title: "NetworkReachability", urlString: "https://reachability.tools"),
        Acknowledgement(title: "SafariView", urlString: "https://vsanthanam.github.io/SafariView")
    ]

    private static let tools = [
        Acknowledgement(title: "Fastlane", urlString: "https://fastlane.tools"),
        Acknowledgement(title: "Jekyll", urlString: "https://jekyllrb.com"),
        Acknowledgement(title: "Tuist", urlString: "https://tuist.io")
    ]

    @State
    private var safariUrl: URL?
}

struct Acknowledgements_Previews: PreviewProvider {
    static var previews: some View {
        Acknowledgements()
    }
}
