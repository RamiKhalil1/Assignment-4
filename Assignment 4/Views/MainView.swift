import SwiftUI

struct MainView: View {
    @StateObject private var quoteManager = QuoteViewModel()
    @State private var moodEntries = PersistenceController.shared.fetchMoodEntries()
    @State private var navigateToSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image(systemName: "sun.max.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .padding(.top, 50)
                    
                    Text("Daily Mood Journal")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                    NavigationLink(destination: CalendarView()) {
                        GradientButton(title: "View Calendar", systemImage: "calendar")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }

                    NavigationLink(destination: QuoteBasedOnMood()) {
                        GradientButton(title: "Generate Quote Based on Mood", systemImage: "lightbulb")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }

                    NavigationLink(destination: SavedEntriesView()) {
                        GradientButton(title: "View Saved Data", systemImage: "folder")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                    
                    Button(action: {
                        navigateToSettings = true
                    }) {
                        GradientButton(title: "Password Settings", systemImage: "gearshape")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                }
                .padding(.horizontal)
            }
            .background(
                NavigationLink(destination: PasswordSettingsView(), isActive: $navigateToSettings) {
                    EmptyView()
                }
            )
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
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
