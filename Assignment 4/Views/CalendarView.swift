import SwiftUI

struct CalendarView: View {
    @State private var moodEntries = PersistenceController.shared.fetchMoodEntries()

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: .init(), count: 7)) {
                ForEach(moodEntries, id: \.date) { entry in
                    Text(entry.mood ?? "")
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .navigationTitle("Mood Calendar")
    }
}
