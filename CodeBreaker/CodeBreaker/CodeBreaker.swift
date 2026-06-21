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
    var guess:Code = Code(kind: .guess)
    var attempts : [Code] = [Code]()
    let pegChoices : [Peg] = [.blue,.red,.green,.yellow] // choices available to make a guess
    
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
}

