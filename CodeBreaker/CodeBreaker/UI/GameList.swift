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
    @State private var showGameEditor: Bool = false
    @State private var gameToEdit : CodeBreaker?
        
    var body: some View {
           List(selection: $selection) { //to expose which selection of List items
               ForEach(games) { game in //iterating over ref to instance of CodeBreaker
                   NavigationLink(value:game) { //specifying what thing to show, with View spec'd elsewhere
                       GameSummary(game:game)
                   }
                   .contextMenu {
                       deleteButton(for: game)
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
               Button("Add Game", systemImage: "plus") {
                   gameToEdit = CodeBreaker(name:"Untitled", pegChoices:[.red, .blue])
               }
               .onChange(of: gameToEdit) {
                   showGameEditor = gameToEdit != nil  // to prevent below sheet being blank
               }
               .sheet(isPresented: $showGameEditor, onDismiss: {
                   if let gameToEdit {
                       games.insert(gameToEdit, at: 0)
                   }
                   gameToEdit = nil
               }) {
                   if let gameToEdit {
                       GameEditor(game:gameToEdit)
                   }
               }
               EditButton()
           }
           .onAppear { addSampleGames() }
    }
     
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage : "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 === game }
            }
        }
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
 
