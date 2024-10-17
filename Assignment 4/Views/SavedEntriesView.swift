import SwiftUI
import CoreData

struct SavedEntriesView: View {
    @FetchRequest(
        entity: Mood.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Mood.date, ascending: false)]
    ) var moodEntries: FetchedResults<Mood>

    var body: some View {
        VStack {
            if moodEntries.isEmpty {
                Text("No entries saved yet. Start tracking your moods and quotes to see them here!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
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
                            
                            if let journalText = entry.journalText, !journalText.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Journal:")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    
                                    Text(journalText)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 5)
                                }
                                .padding(.top, 5)
                            }
                            
                            if let imageData = entry.photo, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 150)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }

                            NavigationLink(destination: EditMoodView(entry: entry)) {
                                Text("Edit")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                    }
                    .onDelete(perform: deleteEntries)
                }
            }
        }
        .navigationTitle("Saved Entries")
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = moodEntries[index]
            PersistenceController.shared.deleteMoodEntry(entry)
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
