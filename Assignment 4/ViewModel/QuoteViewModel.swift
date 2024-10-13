import Foundation

@MainActor
class QuoteViewModel: ObservableObject {
    @Published var quote: Quote?
    @Published var errorMessage: String?

    func fetchQuote(forMood mood: String) async {
        do {
            if let quotes = try await APIService.shared.fetchQuote(forMood: mood), let firstQuote = quotes.first {
                self.quote = firstQuote
            } else {
                self.errorMessage = "No quotes found for the specified mood."
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
