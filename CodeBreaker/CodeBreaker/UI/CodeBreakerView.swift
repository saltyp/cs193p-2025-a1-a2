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
            Button("Restart") {
                withAnimation(.restart){
                    game.restart()
                    selection = 0
                }
            }
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
                    .transition( //transition defined on entire CodeView
                        .attempt(game.isOver)
                    )
                }
            }
            if !game.isOver {
                PegChooser(choices:game.pegChoices, onChoose: changePegAtSelection)
                    .transition(.pegChooser)
            }
        }
        .padding()
    }

    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.guess.pegs.count
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation(.guess) {
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

extension Animation {
    static let codeBreaker = Animation.easeOut(duration: 3)
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(x: 0, y:200)
    static func attempt(_ isOver: Bool)-> AnyTransition {
        return AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge:.top),
            removal: .move(edge:.trailing))
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
