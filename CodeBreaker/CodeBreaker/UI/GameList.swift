//
//
// GameList.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/16/26.
//

import SwiftUI

struct GameList: View {
    //MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?

    // MARK: Data owned by Me
    @State private var games : [CodeBreaker] = []
    @State private var gameToEdit : CodeBreaker?
        
    
    var body: some View {
        List(selection: $selection) { //to expose which selection of List items
            ForEach(games) { game in //iterating over ref to instance of CodeBreaker
                NavigationLink(value:game) { //specifying what thing to show, with View spec'd elsewhere
                    GameSummary(game:game)
                }
                .contextMenu {
                    editButton(for: game) // editing the game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game){
                        .tint(.accentColor)
                }
            }
            .onDelete {offsets in
                games.remove(atOffsets: offsets)
            }
            .onMove {offsets, destination in
                games.move(fromOffsets: offsets, toOffset: destination)
            }
        }
        .onChange(of: games)  {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar { //placed on List, not NavigationStack as NavStack decides when to show toolbar as a fxn of which View it is showing
            addButton
            EditButton() // editing the list of games
        }
        .onAppear { addSampleGames() }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name:"Untitled", pegChoices:[.red, .blue])
        }
        .sheet(isPresented: showGameEditor) { gameEditor } //isPresented set to false when sheet is cancelled, causing set in showGameEditor to be used to set showGameEditor to false
    }
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices) //CodeBreaker is a class so need to create a new instance to create a copy of it
            GameEditor(game:copyOfGameToEdit) {
                if let index = games.firstIndex(of: gameToEdit) {
                    games[index] = copyOfGameToEdit // existing game so replace
                } else { //new game so insert
                    games.insert(copyOfGameToEdit, at: 0)
                }
            }
        }
    }
    
    var showGameEditor: Binding<Bool> {
        Binding<Bool>(get: {
            gameToEdit != nil
        },
          set: { newValue in
            if !newValue {
                gameToEdit = nil
            }
        })
    }
     
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage : "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 === game }
            }
        }
    }
    
    /// editing a particular game
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage : "pencil") {
            gameToEdit = game
        }
        .sheet(isPresented: showGameEditor, onDismiss: { gameToEdit = nil }) { gameEditor }
    }
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name : "Mastermind", pegChoices: [.red, .blue, .yellow, .green]))
            games.append(CodeBreaker(name : "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name : "Under Sea", pegChoices: [.blue, .indigo, .cyan]))
            selection = games[Int.random(in: 0..<games.count)]
        }
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection:$selection)
    }
}
 
