//
//  PlayerTextField.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/22.
//

import SwiftUI

struct PlayerTextField: View {

    let index: Int

    let player: Binding<String>

    var body: some View {
        TextField("Player \(index + 1)", text: player)
            .autocapitalization(.words)
            .keyboardType(.default)
            .disableAutocorrection(true)
    }
}

struct PlayerTextField_Previews: PreviewProvider {
    static var previews: some View {
        PlayerTextField(index: 0, player: .constant("Mom"))
    }
}
