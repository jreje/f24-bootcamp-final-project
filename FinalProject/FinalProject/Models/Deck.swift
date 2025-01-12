//
//  Deck.swift
//  FinalProject
//
//  Created by Julianne Rejesus  on 12/3/24.
//

import Foundation


struct Deck: Codable {
    var id: Int
    var name: String
    var cardIDs: [Int]
    var cards: [Flashcard]
    
    static let example = Deck(
        id: 1,
        name: "Basic Tagalog",
        cardIDs: [1, 2, 3],
        cards: [
            Flashcard(id: 1, question: "Kamusta", answer: "Hello"),
            Flashcard(id: 2, question: "Paalam", answer: "Goodbye"),
            Flashcard(id: 3, question: "Salamat", answer: "Thank you")
        ]
    )
}
