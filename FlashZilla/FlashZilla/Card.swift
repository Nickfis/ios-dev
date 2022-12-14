//
//  Card.swift
//  FlashZilla
//
//  Created by Niklas Fischer on 7/12/22.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
