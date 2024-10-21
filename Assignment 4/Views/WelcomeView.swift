import SwiftUI

struct WelcomeView: View {
    @State private var isActive = false
    @State private var animateSmiley = false
    @State private var animateTitle = false
    @State private var animateSubtitle = false

    var body: some View {
        if isActive {
            MainView()
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    Text("Welcome to Daily Mood Journal")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                        .scaleEffect(animateTitle ? 1.0 : 0.8)
                        .opacity(animateTitle ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 1.2), value: animateTitle)
                    
                    Text("Track Your Moods, One Day at a Time")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .opacity(animateSubtitle ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 1.2).delay(0.5), value: animateSubtitle)

                    Image(systemName: "face.smiling.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                        .scaleEffect(animateSmiley ? 1.2 : 1.0)
                        .opacity(animateSmiley ? 1.0 : 0.5)
                        .animation(
                            Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                            value: animateSmiley
                        )

                    VStack(alignment: .leading, spacing: 10) {
                        FeatureItem(icon: "calendar", text: "View and organize your daily moods with the calendar.")
                        FeatureItem(icon: "lightbulb", text: "Get motivational quotes based on your mood.")
                        FeatureItem(icon: "folder", text: "Save and track your mood history over time.")
                    }
                    .padding(.horizontal, 30)
                    .opacity(animateSubtitle ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.2).delay(0.5), value: animateSubtitle)
                }
                .onAppear {
                    animateTitle = true
                    animateSmiley = true
                    animateSubtitle = true
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct FeatureItem: View {
    var icon: String
    var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            
            Text(text)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    WelcomeView()
}
