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
    // UI @States :
    @State private var selection : Int = 0
    @State private var restarting = false // to sequence guess fading in 1st & attempts *then* moving out by first having guess row appear while attempt is added to Scroll View, @ ca 40:00
    @State private var hideMostRecentMarkers = false
    
    // - MARK: body
    
    var body: some View {
        VStack{
            Button("Restart", action:restart)
            CodeView(code: game.masterCode)
            ScrollView {
                if !game.isOver || restarting { //hitting restart sets above restarting to true, so for sequencing, have guess row appear on screen first
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont()
                    }
                    .animation(nil, value:game.attempts.count) //stop animation of anything w/ guess row changing
                    .opacity(restarting ? 0 : 1) // dont want guess button fading in during restart. put in after animation so that fading in will still happen after restart
                }
                ForEach(game.attempts.indices.reversed(), id:\.self) { ix in
                    CodeView(code:game.attempts[ix]) {
                        let showMarkers = !hideMostRecentMarkers || (ix != game.attempts.count - 1) // only hide markers if supposed to be hiding and not the most recent one
                        if showMarkers, let matches = game.attempts[ix].matches {
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
        
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion : {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
        
    func restart() {
        withAnimation(.restart) {
            restarting = true
        } completion: {
            withAnimation(.restart){
                game.restart()
                selection = 0
                restarting = false
            }
        }
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


#Preview {
    CodeBreakerView()
}
