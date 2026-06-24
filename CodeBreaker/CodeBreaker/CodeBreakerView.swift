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
            view(for:game.masterCode)
            ScrollView {
                view(for:game.guess)
                ForEach(game.attempts.indices.reversed(), id:\.self) {
                    ix in view(for:game.attempts[ix])
                }
            }
            PegChooser(choices:game.pegChoices) {peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.guess.pegs.count
            }
        }
        .padding()
    }
        
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: GuessButton.maxFontSize))
            .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    func view(for code:Code) -> some View {
        HStack {
            CodeView(code:code, selection: $selection)
            Rectangle().foregroundStyle(Color.clear).aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches {
                        MatchMarkers(matches: matches)
                    } else {
                        if code.kind == .guess {
                            guessButton
                        }
                    }
                }
            }
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
