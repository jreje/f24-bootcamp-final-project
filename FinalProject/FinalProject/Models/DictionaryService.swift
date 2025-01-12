//
//  DictionaryService.swift
//  FinalProject
//
//  Created by Julianne Rejesus  on 11/26/24.
//
import Foundation

struct DictionaryService {
    static let tagalogAPIBaseURL = URL(string: "https://raymelon.github.io/tagalog-dictionary-scraper/")
    static let googleTranslateAPIKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    
    
    public static func fetchTranslator(words: [String]) async throws -> [String] {
        SwiftGoogleTranslate.shared.start(with: googleTranslateAPIKey)
        print("Translating...")
        
        let batchSize = 2 // Adjust batch size based on API limits
        var translations: [String] = []
        
        for batch in words.chunked(into: batchSize) {
            let batchTranslations = try await translateBatch(batch)
            translations.append(contentsOf: batchTranslations)
        }
        
        print("Translations: \(translations)")
        return translations
    }

    private static func translateBatch(_ words: [String]) async throws -> [String] {
        print("Translating Batch: \(words)")
        var translations: [String] = []
        await withTaskGroup(of: String?.self) { group in
            for word in words {
                group.addTask {
                    await withCheckedContinuation { continuation in
                        SwiftGoogleTranslate.shared.translate(word, "en", "fil") { (text, error) in
                            if let t = text {
                                continuation.resume(returning: t)
                            } else {
                                continuation.resume(returning: nil)
                            }
                        }
                    }
                }
            }

            for await result in group {
                if let translation = result {
                    print("Appending: \(translation)")
                    translations.append(translation)
                }
            }
        }
        print("Translations: \(translations)")
        return translations
    }

    /* Tagalog Words */
    public static func fetchTagalog(resource: String?) async throws -> [String] {
        // Build URL
        let url: URL
        if let resource = resource, let resourceUrl = URL(string: "https://raymelon.github.io/tagalog-dictionary-scraper/\(resource)") {
            url = resourceUrl
        } else if let baseUrl = tagalogAPIBaseURL {
            url = baseUrl
        } else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Print the raw response for debugging
        /* if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw response data: \(jsonString)")
        } */
        
        let jsonResponse = try JSONDecoder().decode([String: [String]].self, from: data)
        
        // Check the structure of the JSON to see if "data" exists
        guard let words = jsonResponse["data"] else {
            throw URLError(.cannotParseResponse)
        }
        
        return words
    }
    

    /* Translator API translates list of words from Tagalog API */
    public static func fetchTranslations(resource: String, from sourceLang: String, to targetLang: String) async throws -> [String: String] {
        let words = try await fetchTagalog(resource: resource)
        let translations = try await fetchTranslator(words: words)
        return Dictionary(uniqueKeysWithValues: zip(words, translations))
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
