//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/19/26.
//
import SwiftUI

enum Match {
    case exact
    case inexact
    case nomatch
}


struct MatchMarkers: View {
    var matches: [Match]
    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
        }
    }
    func matchMarker (peg:Int) -> some View {
        let exactCount : Int = matches.count(where: { match in match == .exact })
        let foundCount : Int = matches.count(where: { match in match != .nomatch })
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
        
        
    }
}



#Preview {
    let numpegsinrow:[Int] = [3,3,4,4,4,6,6,6]
    VStack(alignment: .leading) {
        ForEach(numpegsinrow, id:\.self) {numpeg in
            HStack(alignment: .bottom) {
                ForEach(1...numpeg, id:\.self) {index in
                    Circle()
                    .foregroundStyle(Color.primary) }
                MatchMarkers(matches: [.exact, .inexact, .inexact])
            }
            .padding()
            .frame(width: nil)
        }
    }.padding(20)
}
