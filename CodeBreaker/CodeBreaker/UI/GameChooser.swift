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
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) { //Binding<NavigationSplitViewVisibility>.constant actually, this communicates that the app starts with .all
            List {
                ForEach(games) { game in //iterating over ref to instance of CodeBreaker
                    NavigationLink(value:game) { //specifying what thing to show, with View spec'd elsewhere
                        GameSummary(game:game)
                    }
                    NavigationLink(value: game.masterCode.pegs) {
                        Text("Cheat")
                    }
                }
                .onDelete {offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove {offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .navigationTitle("Code Breaker")
            .navigationDestination(for: CodeBreaker.self) { //ie CodeBreaker.self :: for values that are of type CodeBreaker
                game in CodeBreakerView(game:game)
                    .navigationTitle(game.name)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationDestination(for: [Peg].self) { pegs in //[Peg].self :: for values that are of type Array<Peg>
                PegChooser(choices: pegs, onChoose: nil)
            }
            .listStyle(.plain)
            .toolbar { //placed on List, not NavigationStack as NavStack decides when to show toolbar as a fxn of which View it is showing
                EditButton()
            }
        } detail: { //rhs
            Text("Choose a Game!")
        }
        .navigationSplitViewStyle(.balanced)
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
