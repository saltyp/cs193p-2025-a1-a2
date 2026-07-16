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
//    @State private var columnVisibility: NavigationSplitViewVisibility = .all //all panes on-screen at the same time
    @State private var selection: CodeBreaker? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) { //Binding<NavigationSplitViewVisibility>.constant actually, this communicates that the app starts with .all
            List(selection: $selection) { //to expose which selection of List items
                ForEach(games) { game in //iterating over ref to instance of CodeBreaker
                    NavigationLink(value:game) { //specifying what thing to show, with View spec'd elsewhere
                        GameSummary(game:game)
                    }
                    .contextMenu {
                        Button("Delete", systemImage : "minus.circle", role: .destructive) {
                            withAnimation {
                                games.removeAll { $0 === game }
                            }
                        }
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
            .navigationTitle("Code Breaker")
            .listStyle(.plain)
            .toolbar { //placed on List, not NavigationStack as NavStack decides when to show toolbar as a fxn of which View it is showing
                EditButton()
            }
        } detail: { //rhs
            if let selection {
                CodeBreakerView(game:selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a Game!")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear { //following is list of action that appears before View appears:
            games.append(CodeBreaker(name : "Mastermind", pegChoices: [.red, .blue, .yellow, .green]))
            games.append(CodeBreaker(name : "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name : "Under Sea", pegChoices: [.blue, .indigo, .cyan]))
            selection = games[Int.random(in: 0..<games.count)]
        }
    }
}

#Preview {
    GameChooser()
}
