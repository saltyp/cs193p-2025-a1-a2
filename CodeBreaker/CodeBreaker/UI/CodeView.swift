//
//  CodeView.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/24/26.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    let code:Code
    // MARK: Data Shared with Me
    @Binding var selection: Int
    @ViewBuilder let ancillaryView: () -> AncillaryView

    init(
        code: Code,
        selection: Binding<Int> = .constant(-1), // default values for the params
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ){
            self.code = code
            self._selection = selection  // use of special var created by @Binding to conform type to Int
            self.ancillaryView = ancillaryView
    }

    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id:\.self) {index in
                PegView(peg:code.pegs[index])
                    .padding(Selection.border)
                    .background {  // selection background
                        if selection == index, code.kind == .guess {
                            Selection.shape.foregroundColor(Selection.color)
                        }
                    }
                    .overlay {  // hidden code obscuring
                        Selection.shape.foregroundStyle(code.isHidden ? Color.gray : .clear)
                            .transaction { transaction in
                                if code.isHidden {
                                    transaction.animation = nil
                                }
                            }
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            Rectangle().foregroundStyle(Color.clear).aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
            }
    }
}

fileprivate struct Selection {
   static let border : CGFloat = 0.5
   static let cornerRadius : CGFloat = 10
   static let color: Color = Color.gray(0.9)
   static let shape = RoundedRectangle(cornerRadius:cornerRadius)
}

//#Preview {
//    CodeView()
//}
