//
//  FormButton.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/22.
//

import SwiftUI

struct FormButton: View {

    let text: String

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .frame(maxWidth: .infinity)
        }
    }
}

struct FormButton_Previews: PreviewProvider {
    static var previews: some View {
        FormButton(text: "test") {}
    }
}
