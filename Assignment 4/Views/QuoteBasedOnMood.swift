import SwiftUI

struct QuoteBasedOnMood: View {
    @State private var selectedCategory: String = "happiness"
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @StateObject private var quoteManager = QuoteViewModel()

    let categories = [
           "age", "alone", "amazing", "anger", "architecture", "art", "attitude",
           "beauty", "best", "birthday", "business", "car", "change", "communication",
           "computers", "cool", "courage", "dad", "dating", "death", "design",
           "dreams", "education", "environmental", "equality", "experience",
           "failure", "faith", "family", "famous", "fear", "fitness", "food",
           "forgiveness", "freedom", "friendship", "funny", "future", "god", "good",
           "government", "graduation", "great", "happiness", "health", "history",
           "home", "hope", "humor", "imagination", "inspirational", "intelligence",
           "jealousy", "knowledge", "leadership", "learning", "legal", "life",
           "love", "marriage", "medical", "men", "mom", "money", "morning",
           "movies", "success"
       ]

    var body: some View {
        ZStack {
                LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
            ScrollView {
                VStack(spacing: 20) {
                    Text("Find Your Inspiration")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .padding(.top, 50)
                    
                    Picker("Select a Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.capitalized)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.white)
                    
                    Button(action: {
                        Task {
                            await quoteManager.fetchQuote(forMood: selectedCategory)
                        }
                    }) {
                        Text("Get Quote")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.9))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Upload Photo")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.9))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(30)
                            .shadow(radius: 5)
                    }
                    
                    if let quote = quoteManager.quote {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Inspirational Quote")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                            
                            Text("\"\(quote.quote ?? "")\"")
                                .font(.body)
                                .foregroundColor(.white)
                                .italic()
                                .multilineTextAlignment(.leading)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                            if let author = quote.author {
                                Text("- \(author)")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .foregroundColor(.white.opacity(0.8))
                                    .italic()
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .shadow(radius: 10)
                        
                        Button("Save Entry") {
                            PersistenceController.shared.saveMoodEntry(
                                date: Date(),
                                mood: selectedCategory,
                                quoteText: quote.quote,
                                quoteAuthor: quote.author,
                                photo: selectedImage
                            )
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        
                        NavigationLink(destination: SavedEntriesView()) {
                            Text("View Saved Data")
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    } else if let errorMessage = quoteManager.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview{
    QuoteBasedOnMood()
}
