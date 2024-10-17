import SwiftUI
import CoreData

struct EditMoodView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var entry: Mood
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedCategory: String = "happiness"
    @State private var journalText: String = ""
    @StateObject private var quoteManager = QuoteViewModel()
    
    let categories = ["age", "alone", "amazing", "anger", "architecture", "art", "attitude", "beauty", "best", "birthday", "business", "car", "change", "communication", "computers", "cool", "courage", "dad", "dating", "death", "design", "dreams", "education", "environmental", "equality", "experience", "failure", "faith", "family", "famous", "fear", "fitness", "food", "forgiveness", "freedom", "friendship", "funny", "future", "god", "good", "government", "graduation", "great", "happiness", "health", "history", "home", "hope", "humor", "imagination", "inspirational", "intelligence", "jealousy", "knowledge", "leadership", "learning", "legal", "life", "love", "marriage", "medical", "men", "mom", "money", "morning", "movies", "success"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Mood and Quote Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Mood: \(entry.mood ?? "Unknown")")
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    if let quoteText = entry.quoteText {
                        Text("Quote: \"\(quoteText)\"")
                            .font(.body)
                            .italic()
                    }
                    
                    if let author = entry.quoteAuthor {
                        Text("- \(author)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                // Journal Entry Section
                Text("Journal Entry")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                TextEditor(text: $journalText)
                    .frame(height: 150)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                
                // Quote Generation Section
                Text("Generate New Quote")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Picker("Select a Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.capitalized)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                
                Button("Get New Quote") {
                    Task {
                        await quoteManager.fetchQuote(forMood: selectedCategory)
                        if let fetchedQuote = quoteManager.quote {
                            entry.mood = selectedCategory
                            entry.quoteText = fetchedQuote.quote ?? ""
                            entry.quoteAuthor = fetchedQuote.author ?? ""
                        }
                    }
                }
                .buttonStyle(GradientButtonStyle())
                
                // Image Upload Section
                Button("Upload Photo") {
                    showImagePicker = true
                }
                .buttonStyle(GradientButtonStyle())
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                
                Button("Save Changes") {
                    saveChanges()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(GradientButtonStyle())
            }
            .padding()
        }
        .onAppear {
            journalText = entry.journalText ?? ""
            if let imageData = entry.photo, let uiImage = UIImage(data: imageData) {
                selectedImage = uiImage
            }
        }
    }
    
    private func saveChanges() {
        PersistenceController.shared.updateMoodEntry(
            entry: entry,
            mood: selectedCategory,
            quoteText: entry.quoteText,
            quoteAuthor: entry.quoteAuthor,
            photo: selectedImage,
            journalText: journalText
        )
    }
}

// Custom button style for consistency
struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: configuration.isPressed ? 0 : 5)
    }
}
