//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/14/26.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Shared By Me
    let game: CodeBreaker //for CodeBreaker being a class, let just means pointer is a let
    // UI @States :
    @State private var selection : Int = 0
    @State private var restarting = false // to sequence guess fading in 1st & attempts *then* moving out by first having guess row appear while attempt is added to Scroll View, @ ca 40:00
    @State private var hideMostRecentMarkers = false
    
    // - MARK: body
    
    var body: some View {
        VStack{
            CodeView(code: game.masterCode)
            ScrollView {
                if !game.isOver { //hitting restart sets above restarting to true, so for sequencing, have guess row appear on screen first ; removed `|| restarting` st guess code isnt there UNTIL restarted
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont()
                    }
                    .animation(nil, value:game.attempts.count) //stop animation of anything w/ guess row changing
                    .opacity(restarting ? 0 : 1) // dont want guess button fading in *during* restart. put in after animation so that fading in will still happen *after* restart.
                }
                ForEach(game.attempts, id: \.pegs) { attempt in // peg is a unique, stable, identifier of attempt
                    CodeView(code:attempt) {
                        let showMarkers = !hideMostRecentMarkers || (attempt.pegs != game.attempts.first?.pegs) // only hide markers if supposed to be hiding and not the most recent one
                        if showMarkers, let matches = attempt.matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                    .transition( //transition defined on entire CodeView
                        .attempt(game.isOver)
                    )
                }
            }
            if !game.isOver {
                PegChooser(choices:game.pegChoices, onChoose: changePegAtSelection)
                    .transition(.pegChooser)
                    .frame(maxHeight: 90)
                
            }
        }
        .onAppear {
            game.startTimer()
        }
        .onDisappear {
            game.pauseTimer()
        }
        .onChange(of: game) {oldGame, newGame in
            oldGame.pauseTimer()
            newGame.startTimer()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction ){//.topBarTrailing) {
                Button("Restart", systemImage: "arrow.circlepath",   action:restart)
                    // .labelStyle(.titleOnly)
            }
            ToolbarItem {
                ElapsedTime(startTime:game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
    //                    .flexibleSystemFont()
                    .monospaced()
                    .lineLimit(1)
            }
        }
        .padding()
    }

    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.guess.pegs.count
    }
        
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion : {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
        
    func restart() {
        withAnimation(.restart) {
            restarting = game.isOver //only do the animation 2-step seq above if game was properly completed before restart
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart){
                
                restarting = false
            }
        }
    }
}


#Preview {
    @Previewable @State var game = CodeBreaker(name: "Preview", pegChoices: [Color.red, .green, .yellow])
    NavigationStack {
        CodeBreakerView(game:game)
    }
}
