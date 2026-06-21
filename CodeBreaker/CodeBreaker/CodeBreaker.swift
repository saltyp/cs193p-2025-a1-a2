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
}


struct Code {
    var kind : Kind
    var pegs : [Peg] = [.blue,.yellow,.blue,.yellow]
    
    enum Kind {
        case mastercode
        case guess
        case attempt
        case unknown
    }
}

