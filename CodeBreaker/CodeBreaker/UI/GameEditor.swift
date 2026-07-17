//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/16/26.
//

import SwiftUI

struct GameEditor: View {
    @Environment(\.dismiss) var dismiss

    @Bindable var game: CodeBreaker //@Bind*able* allows referencing the @Observable and thereby using $game
    
    //MARK: Action Function
    let onChoose: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $game.name)
                }
                Section("Pegs") {
                    PegChoicesChooser(pegChoices: $game.pegChoices)
                }
            }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement:.confirmationAction) {
                        Button("Done") {
                            onChoose()
                            dismiss()
                        }
                    }
                }
        }
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", pegChoices: [.orange, .purple])
    GameEditor(game: game) {
        print("Game name changed to \(game.name)")
        print("Game pegs changed to \(game.pegChoices)")
    }
}
