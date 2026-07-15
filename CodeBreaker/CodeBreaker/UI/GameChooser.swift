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
            List {
                ForEach(games, id: \.pegChoices) { game in //iterating over ref to instance of CodeBreaker
                    NavigationLink {
                        CodeBreakerView(game:game)
                    } label: {
                        GameSummary(game:game)
                    }
                }
                .onDelete {offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove {offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .listStyle(.plain)
            .toolbar { //placed on List, not NavigationStack as NavStack decides when to show toolbar as a fxn of which View it is showing
                EditButton()
            }
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
