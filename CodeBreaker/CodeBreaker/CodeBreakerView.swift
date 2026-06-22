//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/14/26.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game  = CodeBreaker()
    
    var body: some View {
        VStack{
            view(for:game.masterCode)
            ScrollView {
                view(for:game.guess)
                ForEach(game.attempts.indices.reversed(), id:\.self) {
                    ix in view(for:game.attempts[ix])
                }
            }
            newGameButton
        }
        .padding()
    }
    
    var newGameButton: some View {
        Button("New Game") {
            game = CodeBreaker()
        }
        .buttonStyle(.bordered)
        .font(.system(size: 30))
        .minimumScaleFactor(0.1)
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .buttonStyle(.bordered)
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    @ViewBuilder
    func convertStringToView(_ input: String) -> some View {
        let stringToColorMap : [String:Color] = ["green":.green,"red":.red,"black":.black,"blue":.blue,"yellow":.yellow,"clear":.clear]
        if let color = stringToColorMap[input.lowercased()] {
            RoundedRectangle(cornerRadius:10)
                .overlay {
                    if (Code.missing == "clear") {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray)
                    }
                }
                .contentShape(Rectangle())
                .aspectRatio(1,contentMode: .fit)
                .foregroundStyle(color)
        } else {
            Text(input)
        }
    }
    
    
    func view(for code:Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id:\.self) {index in
                convertStringToView(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at:index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                    
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}
