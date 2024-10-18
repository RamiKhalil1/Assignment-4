import SwiftUI
import UIKit

struct EntryView: View {
    var entry: Mood
    @State private var isShareSheetPresented = false
    @State private var isNavigationActive = false
    
    var body: some View {
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

            NavigationLink(destination: EditMoodView(entry: entry), isActive: $isNavigationActive) {
                Text("Edit")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
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

#Preview {
    EntryView(entry: Mood())
}
