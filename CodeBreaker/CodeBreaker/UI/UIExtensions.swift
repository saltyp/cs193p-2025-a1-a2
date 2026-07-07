//
//  UIExtensions.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/6/26.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.easeInOut(duration: 2)//default //easeOut(duration: 3)
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
    static let selection = Animation.codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(x: 0, y:200)
    static func attempt(_ isOver: Bool)-> AnyTransition {
        return AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge:.top),
            removal: .move(edge:.trailing))
    }
}

extension View {
    func flexibleSystemFont(minimum: CGFloat = 8, maximum:CGFloat = 80) -> some View {
        self
            .font(.system(size: maximum)) // GuessButton.maxFontSize))
            .minimumScaleFactor(minimum/maximum)// (GuessButton.scaleFactor)
    }
}

extension Color  {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

