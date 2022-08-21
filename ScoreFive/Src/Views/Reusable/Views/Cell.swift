// ScoreFive
// Cell.swift
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

struct Cell<Content, Detail>: View where Content: View, Detail: View {

    init(@ViewBuilder content: @escaping () -> Content,
         @ViewBuilder detail: @escaping () -> Detail) {
        self.init(content: content,
                  detail: detail,
                  badgeText: nil)
    }

    init(@ViewBuilder content: @escaping () -> Content,
         badge: Text,
         disclosureIndicator: Bool = false) where Detail == AnyView {
        self.init(content: content,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: badge)
    }

    init(@ViewBuilder content: @escaping () -> Content,
         badge: Int,
         disclosureIndicator: Bool = false) where Detail == AnyView {
        self.init(content: content,
                  badge: Text(badge.description),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Badge>(@ViewBuilder content: @escaping () -> Content,
                badge: Badge,
                disclosureIndicator: Bool = false) where Badge: StringProtocol, Detail == AnyView {
        self.init(content: content,
                  badge: Text(badge),
                  disclosureIndicator: disclosureIndicator)
    }

    init(@ViewBuilder content: @escaping () -> Content,
         disclosureIndicator: Bool = false) where Detail == AnyView {
        self.init(content: content,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: nil)
    }

    init<Title, Icon>(@ViewBuilder title: @escaping () -> Title,
                      @ViewBuilder icon: @escaping () -> Icon,
                      @ViewBuilder detail: @escaping () -> Detail) where Title: View, Icon: View, Content == Label<Title, Icon> {
        self.init(content: { Label(title: title, icon: icon) },
                  detail: detail,
                  badgeText: nil)
    }

    init<Title, Icon>(@ViewBuilder title: @escaping () -> Title,
                      @ViewBuilder icon: @escaping () -> Icon,
                      badge: Text,
                      disclosureIndicator: Bool = false) where Title: View, Icon: View, Content == Label<Title, Icon>, Detail == AnyView {
        self.init(content: { Label(title: title, icon: icon) },
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: badge)
    }

    init<Title, Icon>(@ViewBuilder title: @escaping () -> Title,
                      @ViewBuilder icon: @escaping () -> Icon,
                      badge: Int,
                      disclosureIndicator: Bool = false) where Title: View, Icon: View, Content == Label<Title, Icon>, Detail == AnyView {
        self.init(title: title,
                  icon: icon,
                  badge: Text(badge.description),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title, Icon, Badge>(@ViewBuilder title: @escaping () -> Title,
                             @ViewBuilder icon: @escaping () -> Icon,
                             badge: Badge,
                             disclosureIndicator: Bool = false) where Title: View, Icon: View, Content == Label<Title, Icon>, Badge: StringProtocol, Detail == AnyView {
        self.init(title: title,
                  icon: icon,
                  badge: Text(badge),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title, Icon>(@ViewBuilder title: @escaping () -> Title,
                      @ViewBuilder icon: @escaping () -> Icon,
                      disclosureIndicator: Bool = false) where Title: View, Icon: View, Content == Label<Title, Icon>, Detail == AnyView {
        self.init(content: { Label(title: title, icon: icon) },
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: nil)
    }

    init<Title>(_ title: Title,
                systemImage name: String,
                @ViewBuilder detail: @escaping () -> Detail) where Title: StringProtocol, Content == Label<Text, Image> {
        let labelBuilder: () -> Content = {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                Image(systemName: name)
            }
        }
        self.init(content: labelBuilder,
                  detail: detail,
                  badgeText: nil)
    }

    init<Title>(_ title: Title,
                systemImage name: String,
                badge: Text,
                disclosureIndicator: Bool = false) where Title: StringProtocol, Content == Label<Text, Image>, Detail == AnyView {
        let labelBuilder: () -> Content = {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                Image(systemName: name)
            }
        }
        self.init(content: labelBuilder,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: badge)
    }

    init<Title>(_ title: Title,
                systemImage name: String,
                badge: Int,
                disclosureIndicator: Bool = false) where Title: StringProtocol, Content == Label<Text, Image>, Detail == AnyView {
        self.init(title,
                  systemImage: name,
                  badge: Text(badge.description),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title, Badge>(_ title: Title,
                       systemImage name: String,
                       badge: Badge,
                       disclosureIndicator: Bool = false) where Title: StringProtocol, Badge: StringProtocol, Content == Label<Text, Image>, Detail == AnyView {
        self.init(title,
                  systemImage: name,
                  badge: Text(badge),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title>(_ title: Title,
                systemImage name: String,
                disclosureIndicator: Bool = false) where Title: StringProtocol, Content == Label<Text, Image>, Detail == AnyView {
        let labelBuilder: () -> Content = {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                Image(systemName: name)
            }
        }
        self.init(content: labelBuilder,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: nil)
    }

    init<Title>(_ title: Title,
                image name: String,
                @ViewBuilder detail: @escaping () -> Detail) where Title: StringProtocol, Content == Label<Text, Image> {
        let labelBuilder: () -> Content = {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                Image(name)
            }
        }
        self.init(content: labelBuilder,
                  detail: detail,
                  badgeText: nil)
    }

    init<Title>(_ title: Title,
                image name: String,
                badge: Text,
                disclosureIndicator: Bool = false) where Title: StringProtocol, Content == Label<Text, Image>, Detail == AnyView {
        let labelBuilder: () -> Content = {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                Image(name)
            }
        }
        self.init(content: labelBuilder,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: badge)
    }

    init<Title>(_ title: Title,
                image name: String,
                badge: Int,
                disclosureIndicator: Bool = false) where Title: StringProtocol, Content == Label<Text, Image>, Detail == AnyView {
        self.init(title,
                  image: name,
                  badge: Text(badge.description),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title, Badge>(_ title: Title,
                       image name: String,
                       badge: Badge,
                       disclosureIndicator: Bool = false) where Title: StringProtocol, Badge: StringProtocol, Content == Label<Text, Image>, Detail == AnyView {
        self.init(title,
                  image: name,
                  badge: Text(badge),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title>(_ title: Title,
                image name: String,
                disclosureIndicator: Bool = false) where Title: StringProtocol, Content == Label<Text, Image>, Detail == AnyView {
        let labelBuilder: () -> Content = {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                Image(name)
            }
        }
        self.init(content: labelBuilder,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: nil)
    }

    init<Title>(_ title: Title,
                @ViewBuilder detail: @escaping () -> Detail) where Title: StringProtocol, Content == Label<Text, EmptyView> {
        let labelBuilder: () -> Content = {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                EmptyView()
            }
        }
        self.init(content: labelBuilder,
                  detail: detail,
                  badgeText: nil)
    }

    init<Title>(_ title: Title,
                badge: Text,
                disclosureIndicator: Bool = false) where Title: StringProtocol, Content == Label<Text, EmptyView>, Detail == AnyView {
        let labelBuilder: () -> Content = {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                EmptyView()
            }
        }
        self.init(content: labelBuilder,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: badge)
    }

    init<Title>(_ title: Title,
                badge: Int,
                disclosureIndicator: Bool = false) where Title: StringProtocol, Content == Label<Text, EmptyView>, Detail == AnyView {
        self.init(title,
                  badge: Text(badge.description),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title, Badge>(_ title: Title,
                       badge: Badge,
                       disclosureIndicator: Bool = false) where Title: StringProtocol, Badge: StringProtocol, Content == Label<Text, EmptyView>, Detail == AnyView {
        self.init(title,
                  badge: Text(badge),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title>(_ title: Title,
                disclosureIndicator: Bool = false) where Title: StringProtocol, Content == Label<Text, EmptyView>, Detail == AnyView {
        let labelBuilder: () -> Content = {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                EmptyView()
            }
        }
        self.init(content: labelBuilder,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: nil)
    }

    init<Title, Subtitle>(_ title: Title,
                          subtitle: Subtitle,
                          @ViewBuilder detail: @escaping () -> Detail) where Title: StringProtocol, Subtitle: StringProtocol, Content == VStack<TupleView<(Text, Text)>> {
        let labelBuilder: () -> Content = {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.label)
                    .font(.body)
                Text(subtitle)
                    .foregroundColor(.secondaryLabel)
                    .font(.caption)
            }
        }
        self.init(content: labelBuilder,
                  detail: detail,
                  badgeText: nil)
    }

    init<Title, Subtitle>(_ title: Title,
                          subtitle: Subtitle,
                          badge: Text,
                          disclosureIndicator: Bool = false) where Title: StringProtocol, Subtitle: StringProtocol, Content == VStack<TupleView<(Text, Text)>>, Detail == AnyView {
        let labelBuilder: () -> Content = {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.label)
                    .font(.body)
                Text(subtitle)
                    .foregroundColor(.secondaryLabel)
                    .font(.caption)
            }
        }
        self.init(content: labelBuilder,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: badge)
    }

    init<Title, Subtitle, Badge>(_ title: Title,
                                 subtitle: Subtitle,
                                 badge: Badge,
                                 disclosureIndicator: Bool = false) where Title: StringProtocol, Subtitle: StringProtocol, Badge: StringProtocol, Content == VStack<TupleView<(Text, Text)>>, Detail == AnyView {
        self.init(title,
                  subtitle: subtitle,
                  badge: Text(badge),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title, Subtitle>(_ title: Title,
                          subtitle: Subtitle,
                          badge: Int,
                          disclosureIndicator: Bool = false) where Title: StringProtocol, Subtitle: StringProtocol, Content == VStack<TupleView<(Text, Text)>>, Detail == AnyView {
        self.init(title,
                  subtitle: subtitle,
                  badge: Text(badge.description),
                  disclosureIndicator: disclosureIndicator)
    }

    init<Title, Subtitle>(_ title: Title,
                          subtitle: Subtitle,
                          disclosureIndicator: Bool = false) where Title: StringProtocol, Subtitle: StringProtocol, Content == VStack<TupleView<(Text, Text)>>, Detail == AnyView {
        let labelBuilder: () -> Content = {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.label)
                    .font(.body)
                Text(subtitle)
                    .foregroundColor(.secondaryLabel)
                    .font(.caption)
            }
        }
        self.init(content: labelBuilder,
                  detail: { disclosureIndicator ? AnyView(Chevron()) : AnyView(EmptyView()) },
                  badgeText: nil)
    }

    // MARK: - View

    var body: some View {
        if let badgeText = badgeText {
            HStack {
                content()
                    .badge(badgeText)
                detail()
            }
        } else {
            HStack {
                content()
                Spacer()
                detail()
            }
        }
    }

    // MARK: - Private

    private init(@ViewBuilder content: @escaping () -> Content,
                 @ViewBuilder detail: @escaping () -> Detail,
                 badgeText: Text?) {
        self.content = content
        self.detail = detail
        self.badgeText = badgeText
    }

    private let content: () -> Content
    private let detail: () -> Detail
    private let badgeText: Text?

}

struct CellSubtitleLabelStyle: LabelStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            configuration.icon
                .foregroundColor(.accentColor)
                .padding(3)
            configuration.title
                .padding(3)
        }
    }

}

extension Toggle {
    init(isOn: Binding<Bool>) where Label == EmptyView {
        self.init(isOn: isOn, label: { EmptyView() })
    }
}

struct NewCell_Previews: PreviewProvider {

    static var previews: some View {
        List {
            Cell(content: {
                Text("Test")
            })
            Cell(content: {
                Text("Test")
            }, disclosureIndicator: true)
            Cell("Test Cell",
                 systemImage: "envelope",
                 badge: Text("Sup"),
                 disclosureIndicator: true)
            Cell("Title",
                 subtitle: "Subtitle",
                 detail: { EmptyView() })
        }
    }

}
