//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/14/26.
//

import SwiftUI

extension Color {
        private static let namedColors: [String: Color] = [
            "red": .red,
            "blue": .blue,
            "green": .green,
            "yellow": .yellow,
            "orange": .orange,
            "pink": .pink,
            "purple": .purple,
            "mint": .mint,
            "teal": .teal,
            "cyan": .cyan,
            "indigo": .indigo,
            "brown": .brown,
            "gray": .gray,
            "black": .black,
            "white": .white,
            "clear": .clear
        ]

    
    init?(named name: String) {
        guard let color = Self.namedColors[name.lowercased()] else {
            return nil
        }
        self = color
    }
    func randomizedSelection(num: Int) -> [Color] {
        return Array(Color.namedColors.values.shuffled().prefix(num))
        }
}


struct CodeBreakerView: View {
    @State var game  = CodeBreaker()
    
    var body: some View {
        VStack{
            view(for:game.masterCode)
            ScrollView {
                view(for:game.guess)
                ForEach(game.attempts.indices.reversed(), id:\.self) {
                    ix in view(for:game.attempts[ix])
                }
            }
            newGameButton
        }
        .padding()
    }
    
    
    var newGameButton: some View {
        Button("New Game") {
            game = CodeBreaker()
        }
        .buttonStyle(.bordered)
        .font(.system(size: 30))
        .minimumScaleFactor(0.1)
    }
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .buttonStyle(.bordered)
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    @ViewBuilder
    
    func convertStringToView(_ input: String) -> some View {
        ZStack {
            if let color = Color(named:input) {
                RoundedRectangle(cornerRadius:10)
                    .foregroundStyle(color)
                    .overlay {
                        if (Code.missing == "clear") {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
            } else {
                GeometryReader { geometry in
                    Text(input)
                        .font(.system(size: min(geometry.size.width, geometry.size.height)*0.8))
                        .minimumScaleFactor(0.1)
                }
            }
        }
        .contentShape(Rectangle())
        .aspectRatio(1,contentMode: .fit)
    }
    
    func view(for code:Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id:\.self) {index in
                convertStringToView(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at:index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                    
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}
