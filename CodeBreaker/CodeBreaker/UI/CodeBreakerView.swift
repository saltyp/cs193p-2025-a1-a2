//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/14/26.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned By Me
    @State private var game  = CodeBreaker()
    @State private var selection : Int = 0
    
    // - MARK: body
    
    var body: some View {
        VStack{
            CodeView(code: game.masterCode)
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) { guessButton }
                }
                ForEach(game.attempts.indices.reversed(), id:\.self) { ix in
                    CodeView(code:game.attempts[ix]) {
                        if let matches = game.attempts[ix].matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                }
            }
            PegChooser(choices:game.pegChoices, onChoose: changePegAtSelection)
        }
        .padding()
    }

    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.guess.pegs.count
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maxFontSize))
            .minimumScaleFactor(GuessButton.scaleFactor)
    }
        
    struct GuessButton {
        static let minFontSize : CGFloat = 5
        static let maxFontSize : CGFloat = 50
        static let scaleFactor = minFontSize/maxFontSize
        
    }    
}

extension Color  {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}


#Preview {
    CodeBreakerView()
}
