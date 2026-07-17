//
//  PegChoicesChooser.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/17/26.
//

import SwiftUI

struct PegChoicesChooser: View {
    //MARK: Data Shared with Me
    @Binding var pegChoices: [Peg]
    
    var body: some View {
        List {
            ForEach(pegChoices.indices, id: \.self) {ix in
                ColorPicker(
                    selection: $pegChoices[ix],
                    supportsOpacity: false
                ) {
                    button("Peg Choice \(ix+1)", systemImage: "minus.circle", color: .red) {
                        pegChoices.remove(at: ix)
                    }
                    }
            }
            button("Add Peg", systemImage: "plus.circle", color: .green) {
                pegChoices.append(.green)
            }
        }
        
    }
    
    func button(
        _ title: String,
        systemImage : String,
        color:Color?=nil,
        action: @escaping ()-> Void
    ) -> some View {
        HStack {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage).tint(color)
            }
            Text(title)
        }
        
    }
}

#Preview {
    @Previewable @State var pegChoices: [Peg] = [.green, .orange]
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("peg choices = \(pegChoices)")
        }
}
