import Foundation

class APIService {
    static let shared = APIService()
    
    func fetchQuote(forMood mood: String) async throws -> [Quote]? {
        guard let category = mood.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.api-ninjas.com/v1/quotes?category=\(category)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("j5ra3phPi7a54U5XZ7Dl5cvkpTwmWkBJdLywjOsm", forHTTPHeaderField: "X-Api-Key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let decodedQuotes = try JSONDecoder().decode([Quote].self, from: data)
            return decodedQuotes
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
}
