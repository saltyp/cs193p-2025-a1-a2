//
//  Code.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/24/26.
//


import SwiftUI

struct Code: Identifiable {
    var id: [Peg] {pegs} // ObjectIdentifier : a Hashable that identifies this things
    
    var kind : Kind
    var pegs : [Peg] = Array(repeating: Code.missingPeg, count: 4)

    static let missingPeg : Peg = .clear
    
    enum Kind : Equatable { //define enum as Equatable so that we automatically get '==' fxn w/o needing to define it; Hashable as Kind is enum w/ all associated data hashable.
        case mastercode(isHidden:Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for ix in pegs.indices {
            pegs[ix] = pegChoices.randomElement() ?? Code.missingPeg
        }
        print(self)
    }
    
    var isHidden: Bool {
        switch kind {
            case .mastercode(let isHidden): return isHidden
            default: return false
        }
    }
    
    mutating func reset() {
        pegs = Array(repeating: Code.missingPeg, count: 4)
    }
    
    var matches : [Match]? {
        switch kind {
        case .attempt(let matches) : return matches
        default: return nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs  //mutable
        // calculate exact matches: eg results -> [.nomatch, .exact, .nomatch, .exact]
        let backwardsExactMatches = pegs.indices.reversed().map {index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index]  {
                pegsToMatch.remove(at: index)  // eg mastercode pegs removed to avoid double count
                return Match.exact
            } else {
                return .nomatch
            }
        }
        // calculate inexact matches eg results -> [.inexact, .exact, .nomatch, .exact]
        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map {index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    pegsToMatch.remove(at: matchIndex)
                    return .inexact
                } else {
                    return exactMatches[index]
                }
        }
    }
}
