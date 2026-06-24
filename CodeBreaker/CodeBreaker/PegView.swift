//
//  PegView.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/24/26.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    var peg:Peg
    
    // MARK: - body
    let pegShape = RoundedRectangle(cornerRadius:10)
    var body: some View {
        RoundedRectangle(cornerRadius:10)
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1,contentMode: .fit)
            .foregroundStyle(peg)
    }
}

#Preview {
    PegView(peg: .blue).padding()
}
