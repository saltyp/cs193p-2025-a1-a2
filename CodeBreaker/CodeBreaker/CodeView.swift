//
//  CodeView.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/24/26.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data In
    let code:Code
    // MARK: Data Shared with Me
    @Binding var selection: Int
    // MARK: - Body
    
    var body: some View {
        ForEach(code.pegs.indices, id:\.self) {index in
            PegView(peg:code.pegs[index])
                .padding(Selection.border)
                .background {
                    if selection == index, code.kind == .guess {
                        Selection.shape.foregroundColor(Selection.color)
                    }
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
        }
        
    }

     struct Selection {
        static let border : CGFloat = 0.5
        static let cornerRadius : CGFloat = 10
        static let color: Color = Color.gray(0.9)
        static let shape = RoundedRectangle(cornerRadius:cornerRadius)
    }

    
    
}

//#Preview {
//    CodeView()
//}
