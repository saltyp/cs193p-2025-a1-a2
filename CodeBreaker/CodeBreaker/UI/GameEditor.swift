//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/16/26.
//

import SwiftUI

struct GameEditor: View {
    @Bindable var game: CodeBreaker //@Bind*able* allows referencing the @Observable and thereby using $game
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $game.name)
            }
            Section("Pegs") {
                PegChoicesChooser(pegChoices: $game.pegChoices)
            }
        }
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", pegChoices: [.orange, .purple])
    GameEditor(game: game)
        .onChange(of: game.name) {
            print("Game name changed to \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("Game pegs changed to \(game.pegChoices)")
        }
}
