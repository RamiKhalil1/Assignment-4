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
                        EntryView(entry: entry)
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
}

#Preview {
    SavedEntriesView()
}
