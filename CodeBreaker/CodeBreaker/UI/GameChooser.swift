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
        List {
            Section("Games") {
                ForEach(games, id: \.pegChoices) {
                    game in GameSummary(game:game)
                }
            }
            Section(header: Image(systemName: "face.smiling").font(.title)) {
                Text("hello")
                Text("there")
            }
        }
//        .listStyle(.plain)
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
