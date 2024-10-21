import SwiftUI

struct MainView: View {
    @StateObject private var quoteManager = QuoteViewModel()
    @State private var moodEntries = PersistenceController.shared.fetchMoodEntries()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Daily Mood Journal")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                    NavigationLink(destination: CalendarView()) {
                        GradientButton(title: "View Calendar", systemImage: "calendar")
                    }

                    NavigationLink(destination: QuoteBasedOnMood()) {
                        GradientButton(title: "Generate Quote Based on Mood", systemImage: "lightbulb")
                    }

                    NavigationLink(destination: SavedEntriesView()) {
                        GradientButton(title: "View Saved Data", systemImage: "folder")
                    }
                }
                .padding()
            }
        }
    }
}

struct GradientButton: View {
    var title: String
    var systemImage: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
