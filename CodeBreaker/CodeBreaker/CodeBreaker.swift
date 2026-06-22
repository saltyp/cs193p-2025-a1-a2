//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/21/26.
//

import SwiftUI

typealias Peg = Color // no need for enum Peg with just one var

struct CodeBreaker {
    static let codeLength : Int = 5
    var masterCode: Code = Code(kind: .mastercode)
    var guess : Code = Code(kind: .guess)  // current guess in progress
    var attempts : [Code] = [Code]()  // all attempts made
    let pegChoices : [Peg] // choices available to make a guess

    init(pegChoices : [Peg] = [.blue,.red,.green,.yellow] ) {
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices, codeLength: CodeBreaker.codeLength )
//        print(masterCode)
    }
    
    mutating func attemptGuess() {
        // Ignore attempts by the user that they’ve already tried before or which have no pegs chosen at all:
        if attempts.firstIndex(where: { $0 == guess }) != nil { return }
        if guess.pegs.allSatisfy({$0 == Code.missing}) { return }
        var attempt = guess  // change kind of Code to an attempt, from a guess
        attempt.kind = .attempt(guess.match(against: masterCode))  // set kind to an attempt with the associated data of matches
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
    static let numpegs : Int = CodeBreaker.codeLength // static so can use const below. Will be created before self is available
    var pegs : [Peg] = Array(repeating: Code.missing, count: numpegs)

    static let missing : Peg = .clear
    
    enum Kind : Equatable { //define enum as Equatable so that we automatically get '==' fxn w/o needing to define it
        case mastercode
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg], codeLength: Int) {
        for ix in 0..<codeLength {
            pegs[ix] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    var matches : [Match] {
        switch kind {
        case .attempt(let matches) : return matches
        default: return []
        }
    }
    
    static func == (lhs: Code, rhs: Code) -> Bool {
        for ix in lhs.pegs.indices {
            if lhs.pegs[ix] != rhs.pegs[ix] {
                return false
            }
        }
        return true
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results : [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        // calculate exact matches: eg results -> [.nomatch, .exact, .nomatch, .exact]
        for index in pegs.indices.reversed() {
            // exact matches
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index]  {
                results[index] = .exact
                pegsToMatch.remove(at: index)  // eg mastercode pegs removed to avoid double count
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

