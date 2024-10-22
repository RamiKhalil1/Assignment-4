import SwiftUI
import UIKit

struct EntryView: View {
    var entry: Mood
    @State private var isShareSheetPresented = false
    @State private var isNavigationActive = false
    
    @Binding public var isReload: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let date = entry.date {
                Text("Date: \(formattedDate(date))")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Text("Category: \(entry.mood ?? "Unknown")")
                .font(.headline)
                .foregroundColor(.white)
            
            if let quoteText = entry.quoteText {
                Text("\"\(quoteText)\"")
                    .font(.body)
                    .foregroundColor(.white)
                    .italic()
            }
            
            if let author = entry.quoteAuthor {
                Text("- \(author)")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .italic()
            }
            
            if let journalText = entry.journalText, !journalText.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Journal:")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(journalText)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.leading, 5)
                }
                .padding(.top, 5)
            }
            
            if let imageData = entry.photo, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 150)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.top, 5)
            }

            NavigationLink(destination: EditMoodView(entry: entry, isReload: $isReload), isActive: $isNavigationActive) {
                Text("Edit")
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
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(12)
        .padding(.vertical, 5)
        .onTapGesture {
            isNavigationActive = true
        }
        .onLongPressGesture {
            presentShareSheet()
        }
        .sheet(isPresented: $isShareSheetPresented, content: {
            ActivityViewController(activityItems: [shareContent()])
        })
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func presentShareSheet() {
        isShareSheetPresented = true
    }

    private func shareContent() -> String {
        var content = ""
        if let date = entry.date {
            content += "Date: \(formattedDate(date))\n"
        }
        content += "Category: \(entry.mood ?? "Unknown")\n"
        if let quoteText = entry.quoteText {
            content += "\"\(quoteText)\"\n"
        }
        if let author = entry.quoteAuthor {
            content += "- \(author)\n"
        }
        if let journalText = entry.journalText, !journalText.isEmpty {
            content += "\nJournal:\n\(journalText)"
        }
        return content
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
