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
                matchMarker(peg: (matches.count > 3) ? 3 : 0)
                    .opacity(matches.count > 3 ? 1 : 0)
            }
            if (matches.count > 4) {
                VStack {
                    matchMarker(peg: (matches.count > 4) ? 4 : 0)
                        .opacity(matches.count > 4 ? 1 : 0)
                    matchMarker(peg: (matches.count > 5) ? 5 : 0)
                        .opacity(matches.count > 5 ? 1 : 0)
                }}
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
    let numpegsinrow:[Int] = [3,3,4,4,4,6,6,5,5]
    let egmatches = [[Match.exact, .inexact, .inexact],[Match.exact,.nomatch,.nomatch], [Match.exact,.exact,.inexact,.inexact],[Match.exact,.exact,.inexact,.nomatch],
        [Match.exact,.inexact,.nomatch,.nomatch],[Match.exact,.exact,.exact,.inexact],
        [Match.exact,.exact,.exact,.inexact,.inexact,.inexact],
        [Match.exact,.exact,.inexact,.inexact,.inexact],
        [Match.exact,.inexact,.inexact]]
    let circleSize:CGFloat = 40
    let rowWidth: CGFloat = 380
    VStack (alignment: .leading){
        ForEach(numpegsinrow.indices, id:\.self) {ix in
            HStack {
                ForEach(1...numpegsinrow[ix], id:\.self) {_ in
                    Circle()
                    .foregroundStyle(Color.primary) }
                MatchMarkers(matches: egmatches[ix])
            }
            .frame(width: rowWidth, height: 1.1*circleSize, alignment: .leading)
            .padding(15)
        }
    }
}
