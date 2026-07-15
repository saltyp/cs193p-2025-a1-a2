//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/14/26.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games : [CodeBreaker] = []
    
    var body: some View {
        NavigationStack {
            List($games, id: \.pegChoices) { $game in //iterating over *bindable* var (bind in CodeBreakerView
                NavigationLink {
                    CodeBreakerView(game:$game)
                } label: {
                    GameSummary(game:game)
                }
            }
            .listStyle(.plain)
        }
        .onAppear { //following is list of action that appears before View appears:
            games.append(CodeBreaker(name : "Mastermind", pegChoices: [.red, .blue, .yellow, .green]))
            games.append(CodeBreaker(name : "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name : "Under Sea", pegChoices: [.blue, .indigo, .cyan]))
        }
    }
}

#Preview {
    GameChooser()
}
