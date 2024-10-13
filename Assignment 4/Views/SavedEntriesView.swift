import SwiftUI
import CoreData

struct SavedEntriesView: View {
    @FetchRequest(
        entity: Mood.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Mood.date, ascending: false)]
    ) var moodEntries: FetchedResults<Mood>

    var body: some View {
        List {
            ForEach(moodEntries, id: \.self) { entry in
                VStack(alignment: .leading, spacing: 10) {
                    if let date = entry.date {
                        Text("Date: \(formattedDate(date))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Text("Category: \(entry.mood ?? "Unknown")")
                        .font(.headline)
                    
                    if let quoteText = entry.quoteText {
                        Text("\"\(quoteText)\"")
                            .font(.body)
                            .foregroundColor(.primary)
                            .italic()
                    }
                    
                    if let author = entry.quoteAuthor {
                        Text("- \(author)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    
                    if let imageData = entry.photo, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 150)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .padding(.vertical, 5)
            }
            .navigationTitle("Saved Entries")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    SavedEntriesView()
}
