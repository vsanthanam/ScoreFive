//
//  TotalScoreRow.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/22.
//

import SwiftUI

struct TotalScoreBar: View {

    var scores: [Int]

    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text("")
            }
            .frame(width: 48)
            HStack {
                ForEach(scores.indices, id: \.self) { index in
                    Text(scores[index].description)
                        .bold()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 12)
        .background(
            Color(uiColor: UIColor.systemBackground) // any non-transparent background
                .shadow(radius: 10, x: 0, y: 0)
                .mask(Rectangle().padding(.top, -20)) /// here!
        )
    }
}

struct TotalScoreBar_Previews: PreviewProvider {
    static var previews: some View {
        TotalScoreBar(scores: [0, 50, 12, 3])
    }
}
