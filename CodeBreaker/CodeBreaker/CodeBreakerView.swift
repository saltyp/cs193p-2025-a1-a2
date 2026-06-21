//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/14/26.
//

import SwiftUI

struct CodeBreakerView: View {
    let game  = CodeBreaker()
    
    var body: some View {
        VStack{
            pegs(colors:game.MasterCode.pegs)
            pegs(colors:game.guess.pegs)
//            pegs(colors:game.attempts.count > 0 ? game.attempts[game.attempts.count-1].pegs : [])
        }
        .padding()
    }
}

func pegs(colors:Array<Color> = []) -> some View {
    HStack {
        ForEach(colors.indices, id:\.self) {index in
            RoundedRectangle(cornerRadius:10)
                .aspectRatio(1,contentMode: .fit)
            .foregroundStyle(colors[index]) }
        MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
    }
}


#Preview {
    CodeBreakerView()
}
