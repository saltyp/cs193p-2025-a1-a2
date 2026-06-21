//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/21/26.
//

import SwiftUI

typealias Peg = Color // no need for enum Peg with just one var

struct CodeBreaker {
    var MasterCode: Code = Code(kind: .mastercode)
    var guess : Code = Code(kind: .guess)  // current guess in progress
    var attempts : [Code] = [Code]()  // all attempts made
    let pegChoices : [Peg] = [.blue,.red,.green,.yellow] // choices available to make a guess

    mutating func attemptGuess() {
        var attempt = guess // change kind of Code to an attempt, from a guess
        attempt.kind = .attempt
        attempts.append(attempt) // now attempt can be added to attempts
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count] // modulo as need to wrap around if at last index
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
}

struct Code {
    var kind : Kind
    var pegs : [Peg] = [.blue,.yellow,.blue,.yellow]

    static let missing : Peg = .clear
    
    enum Kind {
        case mastercode
        case guess
        case attempt
        case unknown
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results : [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        // calculate exact matches: eg results -> [.nomatch, .exact, .nomatch, .exact]
        for index in pegs.indices.reversed() {
            // exact matches
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index]  {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        // calculate inexact matches eg results -> [.inexact, .exact, .nomatch, .exact]
            for index in pegs.indices {
                if results[index] != .exact {
                    if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                        results[index] = .inexact
                        pegsToMatch.remove(at: matchIndex)
                    }
                }
            }
//        print(pegsToMatch, pegs, results)
        return results
    }
}

