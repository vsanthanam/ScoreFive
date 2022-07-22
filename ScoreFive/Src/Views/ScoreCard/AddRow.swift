//
//  AddRow.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/22.
//

import SwiftUI

struct AddRow: View {

    let signpost: String

    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text(signpost)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            .frame(width: 48)
            VStack(alignment: .center) {
                Text("Add Row")
                    .frame(maxWidth: .infinity)
            }
        }
        .foregroundColor(.init(uiColor: .secondaryLabel))
    }
}

struct AddRow_Previews: PreviewProvider {
    static var previews: some View {
        AddRow(signpost: "X")
    }
}
