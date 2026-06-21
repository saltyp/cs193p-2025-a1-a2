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
            view(for:game.MasterCode)
            ScrollView {
                view(for:game.guess)
                ForEach(game.attempts.indices.reversed(), id:\.self) {
                    ix in view(for:game.attempts[ix])
                }
            }
            Button("Guess") {
                withAnimation {
                    game.attemptGuess()
                }
            }
        }
        .padding()
    }
    
    func view(for code:Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id:\.self) {index in
                RoundedRectangle(cornerRadius:10)
                    .aspectRatio(1,contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at:index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
        }
    }
}

#Preview {
    CodeBreakerView()
}
