import SwiftUI

struct DictionaryView: View {
    @State private var words: [Word] = [] // Holds Tagalog words and translations
    @State private var errorMessage: String? = nil
    @State private var isLoading = false
    @State private var searchText = ""

    var filteredWords: [Word] {
        return words.filter { word in
            searchText.isEmpty || word.tagalog.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading Dictionary...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        ForEach($words) { $word in
                            if filteredWords.contains(where: { $0.id == word.id }) {
                                NavigationLink(destination: WordView(word: $word)) {
                                    Text(word.tagalog)
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText)
                }
            }
            .navigationTitle("Tagalog Dictionary")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: fetchTagalogWords) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                fetchTagalogWords()
            }
        }
    }

    private func fetchTagalogWords() {
        isLoading = true
        Task {
            do {
                let fetchedWords = try await DictionaryService.fetchTagalog(resource: "tagalog_dict.json")
                let initialWords = Array(fetchedWords.prefix(1000)) // Only load the first 1000 words initially
                DispatchQueue.main.async {
                    self.words = initialWords.map { Word(tagalog: $0, translations: []) }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch Tagalog words: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    DictionaryView()
}
