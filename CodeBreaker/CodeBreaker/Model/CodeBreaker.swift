//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by danielringskog on 6/21/26.
//

import SwiftUI

typealias Peg = Color // no need for enum Peg with just one var

@Observable class CodeBreaker { //@Observable for class so that SwiftUI will observe what is changing in class
    
    var name : String
    var masterCode: Code = Code(kind: .mastercode(isHidden: true))
    var guess : Code = Code(kind: .guess)  // current guess in progress
    var attempts : [Code] = [Code]()  // all attempts made
    var pegChoices : [Peg] // choices available to make a guess
    var startTime : Date = Date.now
    var endTime : Date?

    init(name: String = "Code Breaker", pegChoices : [Peg] = [.blue,.red,.green,.yellow] ) {
        self.name = name
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices )
    }
    
    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }
    
    func restart() {
        masterCode.kind = .mastercode(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
    }
    
    func attemptGuess() {
        guard !attempts.contains(where: {$0.pegs == guess.pegs}) else { return }
        var attempt = guess  // change kind of Code to an attempt, from a guess
        attempt.kind = .attempt(guess.match(against: masterCode))  // set kind to an attempt with the associated data of matches
        attempts.insert(attempt, at:0) // now attempt can be added to attempts
        guess.reset()
        if isOver {
            masterCode.kind = .mastercode(isHidden: false)
            endTime = .now
        }
    }
    
    func setGuessPeg(_ peg:Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func changeGuessPeg(at index: Int) {
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

extension CodeBreaker: Identifiable, Hashable {
    static func == (lhs:CodeBreaker, rhs:CodeBreaker) -> Bool {
        //equal if pointers equal
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

