import SwiftUI

struct QuoteBasedOnMood: View {
    @State private var mood: String = ""
    @StateObject private var quoteManager = QuoteViewModel()

    var body: some View {
        VStack {
            TextField("Enter your mood", text: $mood)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Button("Get Quote") {
                Task {
                    await quoteManager.fetchQuote(forMood: mood)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if let quote = quoteManager.quote {
                VStack(alignment: .leading) {
                    Text("Inspirational Quote")
                        .font(.headline)
                    Text("\"\(quote.quote ?? "")\"")
                        .font(.body)
                    if let author = quote.author {
                        Text("- \(author)")
                            .font(.caption)
                            .italic()
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            } else if let errorMessage = quoteManager.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    QuoteBasedOnMood()
}
