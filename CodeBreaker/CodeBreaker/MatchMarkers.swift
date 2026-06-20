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
    let circleSize:CGFloat = 40
    let rowWidth: CGFloat = 380
    VStack (alignment: .leading){
        ForEach(numpegsinrow, id:\.self) {numpeg in
            HStack {
                ForEach(1...numpeg, id:\.self) {index in
                    Circle()
//                        .frame(width: circleSize, height: circleSize)
                    .foregroundStyle(Color.primary) }
                MatchMarkers(matches: [.exact, .inexact, .inexact])
            }
            .frame(width: rowWidth, height: 1.1*circleSize, alignment: .leading)
            .padding(15)
        }
    }
}
