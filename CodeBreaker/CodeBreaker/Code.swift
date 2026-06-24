//
//  Code.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/24/26.
//


import SwiftUI

struct Code {
    var kind : Kind
    var pegs : [Peg] = Array(repeating: Code.missingPeg, count: 4)

    static let missingPeg : Peg = .clear
    
    enum Kind : Equatable { //define enum as Equatable so that we automatically get '==' fxn w/o needing to define it
        case mastercode
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for ix in pegChoices.indices {
            pegs[ix] = pegChoices.randomElement() ?? Code.missingPeg
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
