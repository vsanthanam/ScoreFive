//
//  TotalScoreRow.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/22.
//

import SwiftUI

struct TotalScoreRow: View {

    var scores: [Int]

    var body: some View {
        HStack {
            ForEach(scores, id: \.self) { score in
                Text(score.description)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct TotalScoreRow_Previews: PreviewProvider {
    static var previews: some View {
        TotalScoreRow(scores: [0, 50, 12, 3])
    }
}
