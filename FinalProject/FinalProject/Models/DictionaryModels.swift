//
//  DictionaryModels.swift
//  FinalProject
//
//  Created by Julianne Rejesus  on 12/3/24.
//

import Foundation

/**DICTIONARY MODELS*/
struct Word: Codable, Identifiable {
    let id = UUID()
    var tagalog: String
    var translations: [String]
    
    static let example  = Word(tagalog: "mahal", translations: ["love", "a lot"])
}

struct TranslationRequest: Codable {
    let q: [String]
    let target: String
    let key: String
}

struct TranslationResponse: Codable {
    struct Data: Codable {
        let translations: [Translation]
    }
    
    struct Translation: Codable {
        let translatedText: String
    }
    
    let data: Data
}

