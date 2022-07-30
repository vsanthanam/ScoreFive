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

    struct Acknowledgement: Identifiable {
        var title: String
        var urlString: String
        var id: String { title }
    }

    struct AcknowledgementCell: View {
        init(item: Acknowledgement, url: Binding<URL?>) {
            self.item = item
            self.url = url
        }

        private let item: Acknowledgement
        private let url: Binding<URL?>

        var body: some View {
            Button(action: {
                url.wrappedValue = URL(string: item.urlString)
            }) {
                HStack {
                    Text(item.title)
                        .foregroundColor(.init(.label))
                    Spacer()
                    Chevron()
                }
            }
        }
    }

    let acknowledgements = [
        Acknowledgement(title: "Introspect", urlString: "https://github.com/siteline/SwiftUI-Introspect"),
        Acknowledgement(title: "NetworkReachability", urlString: "https://vsanthanam.github.io/NetworkReachability"),
        Acknowledgement(title: "SafariView", urlString: "https://vsanthanam.github.io/SafariView")
    ]

    var body: some View {
        List(acknowledgements) { acknowledgement in
            AcknowledgementCell(item: acknowledgement, url: $safariUrl)
        }
        .navigationTitle("Acknowledgements")
        .safari(url: $safariUrl) { url in
            SafariView(url: url)
        }
    }

    @State
    private var safariUrl: URL?
}

struct Acknowledgements_Previews: PreviewProvider {
    static var previews: some View {
        Acknowledgements()
    }
}
