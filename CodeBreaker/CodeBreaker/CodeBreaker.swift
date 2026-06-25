//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/21/26.
//

import SwiftUI

typealias Peg = Color // no need for enum Peg with just one var

struct CodeBreaker {
    var masterCode: Code = Code(kind: .mastercode(isHidden: true))
    var guess : Code = Code(kind: .guess)  // current guess in progress
    var attempts : [Code] = [Code]()  // all attempts made
    let pegChoices : [Peg] // choices available to make a guess

    init(pegChoices : [Peg] = [.blue,.red,.green,.yellow] ) {
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices )
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func attemptGuess() {
        var attempt = guess  // change kind of Code to an attempt, from a guess
        attempt.kind = .attempt(guess.match(against: masterCode))  // set kind to an attempt with the associated data of matches
        attempts.append(attempt) // now attempt can be added to attempts
        guess.reset()
        if isOver {
            masterCode.kind = .mastercode(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg:Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count] // modulo as need to wrap around if at last index
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
}

extension Peg {
    static let missing = Color.clear
}



