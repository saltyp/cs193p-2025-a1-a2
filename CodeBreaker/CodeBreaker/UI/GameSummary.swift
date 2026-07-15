//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/14/26.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices, onChoose:nil)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count+1) attempt](inflect:true)") //^[...] makes noun attempt adjust to number
        }
//            .listRowSeparator(.hidden)
//            .listRowBackground(RoundedRectangle(cornerRadius: 10).foregroundStyle(.clear).padding(5))
    }
}

#Preview {
    List {
        GameSummary(game: CodeBreaker(name:"Preview", pegChoices: [.red,.cyan, .yellow]))
    }
    List {
        GameSummary(game: CodeBreaker(name:"Preview", pegChoices: [.red,.cyan, .yellow]))
    }
}
