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
            pegChooser
        }
        .padding()
    }
    
    var pegChooser: some View {
        HStack {
            ForEach(game.pegChoices, id: \.self) { peg in
                Button {
                    game.setGuessPeg(peg, at:selection)
                } label: {
                    PegView(peg:peg)
                }
            }
        }
    }
    
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    func view(for code:Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id:\.self) {index in
                PegView(peg:code.pegs[index])
                    .padding(5)
                    .background {
                        if selection == index, code.kind == .guess {
                            RoundedRectangle(cornerRadius: 10).foregroundColor(Color.gray(0.9))
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
}

extension Color  {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}


#Preview {
    CodeBreakerView()
}
