import SwiftUI
import CoreData

struct SavedEntriesView: View {
    @FetchRequest(
        entity: Mood.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Mood.date, ascending: false)],
        animation: .default
    ) var moodEntries: FetchedResults<Mood>
    
    @State public var isReload: Bool = false
    @State public var fetchTrigger = UUID()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                if moodEntries.isEmpty {
                    Text("No entries saved yet. Start tracking your moods and quotes to see them here!")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List {
                        ForEach(moodEntries, id: \.self) { entry in
                            EntryView(entry: entry, isReload: $isReload)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteEntries)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }
            }
            .padding()
            .navigationTitle("Saved Entries")
            .onChange(of: isReload) { newValue in
                if newValue {
                    fetchTrigger = UUID()
                    isReload = false
                }
            }
        }
        .id(fetchTrigger)
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = moodEntries[index]
            PersistenceController.shared.deleteMoodEntry(entry)
        }
    }
}
