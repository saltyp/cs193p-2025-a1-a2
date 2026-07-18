//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/16/26.
//

import SwiftUI

struct GameEditor: View {
    //MARK: Data (Function) In
    @Environment(\.dismiss) var dismiss

    //MARK: Data Shared with Me
    @Bindable var game: CodeBreaker //@Bind*able* allows referencing the @Observable and thereby using $game
    
    //MARK: Action Function
    let onChoose: () -> Void
    
    //MARK: Data Owned by Me
    @State private var showInvalidGameAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $game.name)
                        .onSubmit {
                            done()
                        }
                        .autocapitalization(.words)
                        .autocorrectionDisabled(true)
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
                            done()
                        }
//                        .disabled(!game.isValid)
                        .alert("Invalid Game", isPresented: $showInvalidGameAlert) {
                            Button("OK") {
                                showInvalidGameAlert = false
                            }
                        } message: {
                            Text("A game must have a name and more than one unique peg.")
                        }
                    }
                }
        }
    }
    
    func done() {
        if game.isValid {
            onChoose()
            dismiss()
        } else {
            showInvalidGameAlert = true
        }
    }
}

extension CodeBreaker {
    var isValid: Bool {
        !name.isEmpty && Set(pegChoices).count >= 2
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", pegChoices: [.orange, .purple])
    GameEditor(game: game) {
        print("Game name changed to \(game.name)")
        print("Game pegs changed to \(game.pegChoices)")
    }
}
