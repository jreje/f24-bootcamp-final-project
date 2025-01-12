import SwiftUI

struct WordView: View {
    @Binding var word: Word // Use @Binding to allow modifications

    var body: some View {
        VStack(alignment: .leading) {
            Text(word.tagalog)
                .font(.headline)
            if word.translations.isEmpty {
                ProgressView()
                    .onAppear {
                        fetchTranslation(for: word)
                    }
            } else {
                Text(word.translations.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    private func fetchTranslation(for word: Word) {
        Task {
            do {
                let translation = try await translateWord(word.tagalog)
                DispatchQueue.main.async {
                    self.word.translations.append(translation) // Modify through the binding
                }
            } catch {
                print("Failed to translate \(word.tagalog): \(error.localizedDescription)")
            }
        }
    }

    private func translateWord(_ word: String) async throws -> String {
        SwiftGoogleTranslate.shared.start(with: ProcessInfo.processInfo.environment["API_KEY"] ?? "")

        return try await withCheckedThrowingContinuation { continuation in
            SwiftGoogleTranslate.shared.translate(word, "en", "fil") { (text, error) in
                if let t = text {
                    continuation.resume(returning: t)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "TranslationError", code: -1, userInfo: nil))
                }
            }
        }
    }
}

#Preview {
    @State var exampleWord = Word.example
    WordView(word: $exampleWord) // Pass a mutable binding for preview
}
