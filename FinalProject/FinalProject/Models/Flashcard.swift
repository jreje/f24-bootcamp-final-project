//
//  Flashcard.swift
//  FinalProject
//
//  Created by Julianne Rejesus  on 12/3/24.
//

import Foundation

struct Flashcard: Codable, Identifiable {
    let id: Int
    let question: String
    let answer: String
    
    static var example: Flashcard {
        Flashcard(id: 1, question: "Buhay", answer: "Life")
    }
}
