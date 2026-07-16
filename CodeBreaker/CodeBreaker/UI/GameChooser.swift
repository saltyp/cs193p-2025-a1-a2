//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by danielringskog on 7/14/26.
//

import SwiftUI

struct GameChooser: View {
    
    // MARK: Data Owned by Me
//    @State private var columnVisibility: NavigationSplitViewVisibility = .all //all panes on-screen at the same time
    @State private var selection: CodeBreaker? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) { //Binding<NavigationSplitViewVisibility>.constant actually, this communicates that the app starts with .all
            GameList(selection:$selection)
            .navigationTitle("Code Breaker")
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
    }
}

#Preview {
    GameChooser()
}
