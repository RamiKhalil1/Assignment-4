import SwiftUI
import CoreData

struct EditMoodView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var entry: Mood
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedCategory: String = ""
    @State private var journalText: String = ""
    @StateObject private var quoteManager = QuoteViewModel()
    
    let categories = ["age", "alone", "amazing", "anger", "architecture", "art", "attitude", "beauty", "best", "birthday", "business", "car", "change", "communication", "computers", "cool", "courage", "dad", "dating", "death", "design", "dreams", "education", "environmental", "equality", "experience", "failure", "faith", "family", "famous", "fear", "fitness", "food", "forgiveness", "freedom", "friendship", "funny", "future", "god", "good", "government", "graduation", "great", "happiness", "health", "history", "home", "hope", "humor", "imagination", "inspirational", "intelligence", "jealousy", "knowledge", "leadership", "learning", "legal", "life", "love", "marriage", "medical", "men", "mom", "money", "morning", "movies", "success"]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.9), .purple.opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text("Edit Mood Entry")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)

                    moodQuoteSection

                    journalEntrySection

                    categoryPicker

                    generateQuoteButton

                    imageUploadSection

                    saveChangesButton
                }
                .padding()
            }
            .onAppear {
                selectedCategory = entry.mood ?? "happiness"
                journalText = entry.journalText ?? ""
                if let imageData = entry.photo, let uiImage = UIImage(data: imageData) {
                    selectedImage = uiImage
                }
            }
        }
    }
    
    private var moodQuoteSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood: \(entry.mood ?? "Unknown")")
                .font(.headline)
                .foregroundColor(.white)
            
            if let quoteText = entry.quoteText {
                Text("Quote: \"\(quoteText)\"")
                    .font(.body)
                    .foregroundColor(.white)
                    .italic()
            }
            
            if let author = entry.quoteAuthor {
                Text("- \(author)")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .italic()
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(12)
    }

    private var journalEntrySection: some View {
        VStack(alignment: .leading) {
            Text("Journal Entry")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            TextEditor(text: $journalText)
                .frame(height: 150)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
        }
    }

    private var categoryPicker: some View {
        Picker("Select a Category", selection: $selectedCategory) {
            ForEach(categories, id: \.self) { category in
                Text(category.capitalized)
                    .foregroundColor(.black)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
    }

    private var generateQuoteButton: some View {
        Button(action: {
            Task {
                await quoteManager.fetchQuote(forMood: selectedCategory)
                if let fetchedQuote = quoteManager.quote {
                    entry.mood = selectedCategory
                    entry.quoteText = fetchedQuote.quote ?? ""
                    entry.quoteAuthor = fetchedQuote.author ?? ""
                }
            }
        }) {
            Text("Generate New Quote")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }

    private var imageUploadSection: some View {
        VStack(spacing: 10) {
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
        }
    }

    private var saveChangesButton: some View {
        Button("Save Changes") {
            saveChanges()
            presentationMode.wrappedValue.dismiss()
        }
        .buttonStyle(GradientButtonStyle())
    }

    private func saveChanges() {
        entry.mood = selectedCategory
        entry.journalText = journalText
        if let selectedImage = selectedImage {
            entry.photo = selectedImage.jpegData(compressionQuality: 0.8)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing)
            )
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: configuration.isPressed ? 0 : 5)
    }
}
