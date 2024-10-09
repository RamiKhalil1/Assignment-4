import SwiftUI

struct MainView: View {
    @StateObject private var quoteManager = QuoteViewModel()
    @State private var moodEntries = PersistenceController.shared.fetchMoodEntries()

    var body: some View {
        NavigationView {
            VStack {
                List(moodEntries, id: \.date) { entry in
                    Text("Mood: \(entry.mood ?? "") on \(entry.date ?? Date())")
                }
                
                NavigationLink(destination: CalendarView()) {
                    Text("View Calendar")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: QuoteBasedOnMood()) {
                    Text("Generate quote based on mood")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Daily Mood Journal")
        }
    }
}

#Preview {
    MainView()
}
